require 'spec_helper'
require 'gandi'

describe Gandi::Domain do
  before do
    @connection_mock = double()
    ::Gandi.connection = @connection_mock
  end
  
  describe '.list' do
    let(:domain_list) { [domain_information_attributes_hash('fqdn' => 'domain1.com'), domain_information_attributes_hash('fqdn' => 'domain2.net')] }
    
    before do
      @connection_mock.should_receive(:call).with('domain.list', {}).and_return(domain_list)
      @connection_mock.should_receive(:call).with('domain.info', 'domain1.com').and_return(domain_information_attributes_hash('fqdn' => 'domain1.com'))
      @connection_mock.should_receive(:call).with('domain.info', 'domain2.net').and_return(domain_information_attributes_hash('fqdn' => 'domain2.net'))
    end
    
    it "returns an array of domain objects" do
      list = Gandi::Domain.list
      list.length.should == domain_list.length
      list.first.should be_a(Gandi::Domain)
      list.first.fqdn.should == domain_list.first['fqdn']
    end
  end
  
  describe '.count' do
    before do
      @connection_mock.should_receive(:call).with('domain.count', {}).and_return(42)
    end
    
    it "returns an integer" do
      Gandi::Domain.count.should == 42
    end
  end
  
  describe '.available' do
    let(:fqdns) { ['domain1.com', 'domain2.net'] }
    
    it "returns a hash of fqdns" do
      fqdns_available_call_result = {"domain1.com"=>"unavailable", "domain2.net"=>"available"}
      @connection_mock.should_receive(:call).with('domain.available', fqdns).and_return(fqdns_available_call_result)
      
      Gandi::Domain.available(fqdns).should == fqdns_available_call_result
    end
    
    pending "should wait then recall the method when getting pending results"
  end
  
  describe '.create' do
    let(:handle) { 'FLN123-GANDI' }
    let(:domain_creation_params) { {'owner' => handle, 'admin' => handle, 'tech' => handle, 'bill' => handle, 'nameservers' => ['gandi.net'], 'duration' => 1} }
    let(:fqdn) { 'domain1.com' }
    
    before do
      @connection_mock.should_receive(:call).with('domain.create', fqdn, domain_creation_params).and_return(domain_creation_operation_hash('id' => 42))
    end
    
    it "returns an operation object" do
      domain_operation = Gandi::Domain.create(fqdn, domain_creation_params)
      domain_operation.should be_a(Gandi::Operation)
      domain_operation.id.should == 42
    end
  end
  
  context "an instance" do
    let(:fqdn) { 'domain1.tld' }
    let(:domain_attributes) { domain_information_attributes_hash('fqdn' => fqdn) }
    
    before do
      @connection_mock.should_receive(:call).with('domain.info', fqdn).and_return(domain_attributes)
    end
    subject { Gandi::Domain.new(fqdn) }
    
    its(:fqdn) { should == fqdn }
    
    it "can fetch its informations" do
      @connection_mock.should_receive(:call).with('domain.info', fqdn).and_return(domain_attributes)
      subject.info['fqdn'].should == domain_attributes['fqdn']
    end
    
    it "can read its attributes" do
      subject.to_hash.should == domain_attributes
      subject['tld'].should == domain_attributes['tld']
    end
    
    it "can be renewed" do
      renewal_spec = domain_renew_spec
      @connection_mock.should_receive(:call).with('domain.renew', fqdn, renewal_spec).and_return(domain_renewal_operation_hash('id' => 42))
      
      domain_renewal_operation = subject.renew(renewal_spec)
      domain_renewal_operation.should be_a(Gandi::Operation)
      domain_renewal_operation.id.should == 42
    end
    
    pending "has attributes writers and readers"
    
    it "has contacts" do
      @connection_mock.should_receive(:call).exactly(5).times.with('contact.info', 'FLN123-GANDI').and_return(contact_information_attributes_hash('handle' => 'FLN123-GANDI'))
      
      contacts = subject.contacts
      contacts['owner'].should be_a(Gandi::Contact)
      contacts['owner'].handle.should == 'FLN123-GANDI'
    end
    
    it "can set its contacts" do
      contacts_update_hash = {
        "admin"=>"FLN123-GANDI", 
        "bill"=>"FLN123-GANDI", 
        "tech"=>"FLN123-GANDI"
      }
      @connection_mock.should_receive(:call).with('domain.contacts.set', fqdn, contacts_update_hash).and_return(operation_information_attributes_hash('id' => 42))
      
      contacts_change = subject.contacts = contacts_update_hash
      #contacts_change.should be_a(Gandi::Operation)
      #contacts_change.id.should == 42
      contacts_change.should == contacts_update_hash
    end
    
    pending "can set its contacts using a hash of contacts objects"
    
    it 'can be locked' do
      @connection_mock.should_receive(:call).with('domain.status.lock', fqdn).and_return(operation_information_attributes_hash('id' => 42))
      
      domain_lock_operation = subject.lock
      domain_lock_operation.should be_a(Gandi::Operation)
      domain_lock_operation.id.should == 42
    end
    
    pending 'cannot be locked if already locked'
    
    it 'can be unlocked' do
      @connection_mock.should_receive(:call).with('domain.status.unlock', fqdn).and_return(operation_information_attributes_hash('id' => 42))
      
      domain_lock_operation = subject.unlock
      domain_lock_operation.should be_a(Gandi::Operation)
      domain_lock_operation.id.should == 42
    end
    
    pending 'cannot be unlocked if already unlocked'
    
    pending '#locked?'
    
    it 'can be transferred' do
      handle = 'FLN123-GANDI'
      params = {'owner' => handle, 'admin' => handle, 'bill' => handle, 'tech' => handle}
      @connection_mock.should_receive(:call).with('domain.transferin.proceed', fqdn, params).and_return(operation_information_attributes_hash('id' => 42))
      
      domain_lock_operation = subject.transferin(params)
      domain_lock_operation.should be_a(Gandi::Operation)
      domain_lock_operation.id.should == 42
    end
    
    it "has nameservers" do
      subject.nameservers.should == domain_attributes['nameservers']
    end
    
    it "can set its nameservers" do
      new_nameservers = ['a.dns.gandi-ote.net', 'b.dns.gandi-ote.net', 'c.dns.gandi-ote.net']
      @connection_mock.should_receive(:call).with('domain.nameservers.set', fqdn, new_nameservers).and_return(operation_information_attributes_hash('id' => 42))
      
      namservers_change = subject.nameservers=(new_nameservers)
      #namservers_change.should be_a(Gandi::Operation)
      #namservers_change.id.should == 42
      namservers_change.should == new_nameservers
    end
  end
end
