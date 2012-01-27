require 'spec_helper'
require 'gandi'

describe Gandi::Domain::Host do
  before do
    @connection_mock = double()
    ::Gandi.connection = @connection_mock
  end
  
  describe '.list' do
    let(:fqdn) { 'domain1.tld' }
    let(:domain_host_list) { [{"ips"=>["1.2.3.4"], "name"=>"dns1.domain1.tld"}, {"ips"=>["6.7.8.9"], "name"=>"dns2.domain1.tld"}] }
    
    before do
      @connection_mock.should_receive(:call).with('domain.host.list', fqdn, {}).and_return(domain_host_list)
    end
    
    it "returns an array of Host objects" do
      list = Gandi::Domain::Host.list(fqdn)
      list.length.should == domain_host_list.length
      list.first.should be_a(Gandi::Domain::Host)
      list.first.hostname.should == domain_host_list.first['name']
    end
  end
  
  describe '.count' do
    let(:fqdn) { 'domain1.tld' }
    
    before do
      @connection_mock.should_receive(:call).with('domain.host.count', fqdn, {}).and_return(42)
    end
    
    it "returns an integer" do
      Gandi::Domain::Host.count(fqdn).should == 42
    end
  end
  
  describe '.create' do
    let(:host_ips) { ["1.2.3.4"] }
    let(:hostname) { 'dns1.domain1.tld' }
    
    before do
      @connection_mock.should_receive(:call).with('domain.host.create', hostname, host_ips).and_return(operation_information_attributes_hash('id' => 42))
    end
    
    it "returns an operation object" do
      host_operation = Gandi::Domain::Host.create(hostname, host_ips)
      host_operation.should be_a(Gandi::Operation)
      host_operation.id.should == 42
    end
  end
  
  it "can be instanciated with its attributes" do
    hostname = 'domain1.tld'
    host_attributes = domain_host_attributes_hash('name' => hostname)
    
    host = Gandi::Domain::Host.new(hostname, host_attributes)
    host.to_hash.should == host_attributes
    host.hostname.should == hostname
  end
  
  context "an instance" do
    let(:hostname) { 'domain1.tld' }
    let(:host_attributes) { domain_host_attributes_hash('name' => hostname) }
    
    before do
      @connection_mock.should_receive(:call).with('domain.host.info', hostname).and_return(host_attributes)
    end
    subject { Gandi::Domain::Host.new(hostname) }
    
    its(:hostname) { should == hostname }
    its(:ips) { should == host_attributes['ips'] }
    
    pending '#domain'
    
    it "can fetch its informations" do
      @connection_mock.should_receive(:call).with('domain.host.info', hostname).and_return(host_attributes)
      subject.info['ips'].should == host_attributes['ips']
    end
    
    it "can read its attributes" do
      subject.to_hash.should == host_attributes
      subject['ips'].should == host_attributes['ips']
    end
    
    it "can be deleted" do
      @connection_mock.should_receive(:call).with('domain.host.delete', hostname).and_return(operation_information_attributes_hash('id' => 42))
      
      host_deletion = subject.delete
      host_deletion.should be_a(Gandi::Operation)
      host_deletion.id.should == 42
    end
    
    it "can be updated" do
      new_ips = ['5.6.7.8']
      @connection_mock.should_receive(:call).with('domain.host.update', hostname, new_ips).and_return(operation_information_attributes_hash('id' => 42))
      
      host_update = subject.update(new_ips)
      host_update.should be_a(Gandi::Operation)
      host_update.id.should == 42
    end
  end
end
