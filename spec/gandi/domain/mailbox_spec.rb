require 'spec_helper'
require 'gandi'

describe Gandi::Domain::Mailbox do
  before do
    @connection_mock = double()
    ::Gandi.connection = @connection_mock
  end
  
  describe '.list' do
    let(:fqdn) { 'domain1.tld' }
    let(:domain) { mock_domain(fqdn) }
    let(:domain_mailboxes_list) { [domain_mailbox_attributes('login' => 'john.doe'), domain_mailbox_attributes('login' => 'jane.doe'), domain_mailbox_attributes('login' => 'tom.doe')] }
    
    before do
      @connection_mock.should_receive(:call).with('domain.mailbox.list', fqdn, {}).and_return(domain_mailboxes_list)
    end
    
    it "returns an array of Mailbox objects by default" do
      domain_mailboxes_list.each do |mailbox_hash|
        @connection_mock.should_receive(:call).with('domain.mailbox.info', fqdn, mailbox_hash['login']).and_return(mailbox_hash)
      end
      
      list = Gandi::Domain::Mailbox.list(domain)
      list.length.should == domain_mailboxes_list.length
      list.first.should be_a(Gandi::Domain::Mailbox)
      list.first.login.should == domain_mailboxes_list.first['login']
    end
    
    it "returns an array of hashes if map_mailboxes is false" do
      list = Gandi::Domain::Mailbox.list(domain, {}, false)
      list.should == domain_mailboxes_list
    end
  end
  
  describe '.count' do
    let(:fqdn) { 'domain1.tld' }
    let(:domain) { mock_domain(fqdn) }
    
    before do
      @connection_mock.should_receive(:call).with('domain.mailbox.count', fqdn, {}).and_return(42)
    end
    
    it "returns an integer" do
      Gandi::Domain::Mailbox.count(domain).should == 42
    end
  end
  
  describe '.create' do
    let(:fqdn) { 'domain1.tld' }
    let(:domain) { mock_domain(fqdn) }
    let(:login) { 'john.doe' }
    let(:mailbox_create_params) { {'password' => 'securedp4ssword'} }
    
    before do
      @connection_mock.should_receive(:call).with('domain.mailbox.create', fqdn, login, mailbox_create_params).and_return(mailbox_create_params)
    end
    
    it "returns a Mailbox object" do
      mailbox = Gandi::Domain::Mailbox.create(domain, login, mailbox_create_params)
      mailbox.should be_a(Gandi::Domain::Mailbox)
      mailbox.login.should == login
    end
  end
  
  it "can be instanciated with its attributes" do
    fqdn = 'domain1.tld'
    domain = mock_domain(fqdn)
    login = 'john.doe'
    mailbox_attributes = domain_mailbox_attributes('login' => login)
    
    mailbox = Gandi::Domain::Mailbox.new(domain, login, mailbox_attributes)
    mailbox.to_hash.should == mailbox_attributes
    mailbox.login.should == login
    mailbox.domain.should == domain
  end
  
  context "an instance" do
    let(:fqdn) { 'domain1.tld' }
    let(:domain) { mock_domain(fqdn) }
    let(:login) { 'john.doe' }
    let(:mailbox_attributes) { domain_mailbox_attributes('name' => login) }
    
    before do
      @connection_mock.should_receive(:call).with('domain.mailbox.info', fqdn, login).and_return(mailbox_attributes)
    end
    subject { Gandi::Domain::Mailbox.new(domain, login) }
    
    its(:login) { should == login }
    its(:domain) { should == domain }
    
    it "can fetch its informations" do
      @connection_mock.should_receive(:call).with('domain.mailbox.info', fqdn, login).and_return(mailbox_attributes)
      subject.info['ips'].should == mailbox_attributes['ips']
    end
    
    it "can read its attributes" do
      subject.to_hash.should == mailbox_attributes
      subject['login'].should == mailbox_attributes['login']
    end
    
    it "can be deleted" do
      @connection_mock.should_receive(:call).with('domain.mailbox.delete', fqdn, login).and_return(true)
      
      subject.delete.should be_true
    end
    
    it "can be updated" do
      new_attrs = mailbox_attributes.merge('password' => 'newpassword')
      @connection_mock.should_receive(:call).with('domain.mailbox.update', fqdn, login, new_attrs).and_return(operation_information_attributes_hash('id' => 42))
      
      mailbox_update = subject.update(new_attrs)
      mailbox_update.should be_a(Gandi::Operation)
      mailbox_update.id.should == 42
    end
  end
end
