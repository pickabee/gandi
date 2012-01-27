require 'spec_helper'
require 'gandi'

describe Gandi::Domain::Forward do
  before do
    @connection_mock = double()
    ::Gandi.connection = @connection_mock
  end
  
  describe '.list' do
    let(:fqdn) { 'domain1.tld' }
    let(:domain) { mock_domain(fqdn) }
    let(:domain_forwards_list) { [domain_forward_attributes('john.doe'), domain_forward_attributes('jane.doe'), domain_forward_attributes('tom.doe')] }
    
    before do
      @connection_mock.should_receive(:call).with('domain.forward.list', fqdn, {}).and_return(domain_forwards_list)
    end
    
    it "returns an array of Forward objects" do
      list = Gandi::Domain::Forward.list(domain)
      list.length.should == domain_forwards_list.length
      list.first.should be_a(Gandi::Domain::Forward)
      list.first.source.should == domain_forwards_list.first['source']
    end
  end
  
  describe '.count' do
    let(:fqdn) { 'domain1.tld' }
    let(:domain) { mock_domain(fqdn) }
    
    before do
      @connection_mock.should_receive(:call).with('domain.forward.count', fqdn, {}).and_return(42)
    end
    
    it "returns an integer" do
      Gandi::Domain::Forward.count(domain).should == 42
    end
  end
  
  describe '.create' do
    let(:fqdn) { 'domain1.tld' }
    let(:domain) { mock_domain(fqdn) }
    let(:source) { 'john.doe' }
    let(:forward_create_params) { {'password' => 'securedp4ssword'} }
    
    before do
      @connection_mock.should_receive(:call).with('domain.forward.create', fqdn, source, forward_create_params).and_return(forward_create_params)
    end
    
    it "returns a Forward object" do
      forward = Gandi::Domain::Forward.create(domain, source, forward_create_params)
      forward.should be_a(Gandi::Domain::Forward)
      forward.source.should == source
    end
  end
  
  it "can be instanciated with its attributes" do
    fqdn = 'domain1.tld'
    domain = mock_domain(fqdn)
    source = 'john.doe'
    forward_attributes = domain_forward_attributes(source)
    
    forward = Gandi::Domain::Forward.new(domain, source, forward_attributes)
    forward.to_hash.should == forward_attributes
    forward.source.should == source
    forward.domain.should == domain
  end
  
  context "an instance" do
    let(:fqdn) { 'domain1.tld' }
    let(:domain) { mock_domain(fqdn) }
    let(:source) { 'john.doe' }
    let(:forward_attributes) { domain_forward_attributes(source) }
    
    before do
      @connection_mock.should_receive(:call).with('domain.forward.list', fqdn, {'source' => source}).and_return([forward_attributes])
    end
    subject { Gandi::Domain::Forward.new(domain, source) }
    
    its(:source) { should == source }
    its(:domain) { should == domain }
    
    it "can read its attributes" do
      subject.to_hash.should == forward_attributes
      subject['destinations'].should == forward_attributes['destinations']
    end
    
    it "can be deleted" do
      @connection_mock.should_receive(:call).with('domain.forward.delete', fqdn, source).and_return(true)
      
      subject.delete.should be_true
    end
    
    it "can be updated" do
      new_attrs = forward_attributes.merge('destinations' => ['jean.dupond@domain1.tld'])
      @connection_mock.should_receive(:call).with('domain.forward.update', fqdn, source, new_attrs).and_return(new_attrs)
      
      same_subject = subject.update(new_attrs)
      same_subject.should == subject
      subject.destinations.should == new_attrs['destinations']
    end
  end
end
