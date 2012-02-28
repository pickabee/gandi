require 'spec_helper'
require 'gandi'

describe Gandi::Domain::Zone do
  let(:fqdn) { 'domain1.tld' }
  
  before do
    @connection_mock = double()
    ::Gandi.connection = @connection_mock
  end
  
  describe '.list' do
    let(:domain_zones_list) { [domain_zone_list_attributes, domain_zone_list_attributes('name' => '2nd zone', 'id' => 2)] }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.list', {}).and_return(domain_zones_list)
    end
    
    it "returns an array of hashes" do
      Gandi::Domain::Zone.list.should == domain_zones_list
    end
  end
  
  describe '.count' do
    before do
      @connection_mock.should_receive(:call).with('domain.zone.count', {}).and_return(42)
    end
    
    it "returns an integer" do
      Gandi::Domain::Zone.count.should == 42
    end
  end
  
  describe '.create' do
    let(:zone_name) { "My new Zone" }
    let(:domain_zone_attributes) { domain_zone_info_attributes }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.create', zone_name).and_return(domain_zone_attributes)
    end
    
    it "returns a Zone object" do
      zone = Gandi::Domain::Zone.create(zone_name)
      zone.should be_a(Gandi::Domain::Zone)
      zone.id.should == domain_zone_attributes['id']
      zone.to_hash.should == domain_zone_attributes
    end
  end
  
  describe '.info' do
    let(:zone_id) { 42 }
    let(:domain_zone_attributes) { domain_zone_info_attributes('id' => zone_id) }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.info', zone_id).and_return(domain_zone_attributes)
    end
    
    it "returns a hash" do
      Gandi::Domain::Zone.info(zone_id).should == domain_zone_attributes
    end
  end
  
  describe '.find' do
    let(:zone_id) { 42 }
    let(:domain_zone_attributes) { domain_zone_info_attributes('id' => zone_id) }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.info', zone_id).and_return(domain_zone_attributes)
    end
    
    it "returns a Zone object" do
      zone = Gandi::Domain::Zone.find(zone_id)
      zone.should be_a(Gandi::Domain::Zone)
      zone.id.should == domain_zone_attributes['id']
    end
  end
  
  describe '.clone' do
    let(:zone_id) { 42 }
    let(:new_zone_id) { 43 }
    let(:zone_attributes) { domain_zone_info_attributes('id' => new_zone_id) }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.clone', zone_id, 0, {}).and_return(zone_attributes)
    end
    
    it "returns a hash" do
      zone = Gandi::Domain::Zone.clone(zone_id)
      zone['id'].should == new_zone_id
    end
  end
  
  describe '.delete' do
    let(:zone_id) { 42 }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.delete', zone_id).and_return(true)
    end
    
    it "returns an integer" do
      Gandi::Domain::Zone.delete(zone_id).should be_true
    end
  end
  
  describe '.set' do
    let(:zone_id) { 42 }
    let(:domain_attributes) { domain_information_attributes_hash('fqdn' => fqdn, zone_id => zone_id) }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.set', fqdn, zone_id).and_return(domain_attributes)
    end
    
    it "returns a domain hash" do
      domain_hash = Gandi::Domain::Zone.set(fqdn, zone_id)
      domain_hash.should == domain_attributes
    end
  end
  
  describe '.update' do
    let(:zone_id) { 42 }
    let(:zone_attributes) { domain_zone_info_attributes('id' => zone_id) }
    let(:zone_params) { {'name' => "New Name"} }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.update', zone_id, zone_params).and_return(zone_attributes.merge(zone_params))
    end
    
    it "returns a Zone hash" do
      zone_hash = Gandi::Domain::Zone.update(zone_id, zone_params)
      zone_hash['name'].should == "New Name"
    end
  end
  
  context 'given an instance' do
    let(:zone_id) { 42 }
    let(:zone_attributes) { domain_zone_info_attributes('id' => zone_id) }
    let(:zone) { Gandi::Domain::Zone.new(zone_attributes) }
    
    subject { zone }
    
    it "can read its attributes" do
      subject.to_hash.should == zone_attributes
      subject['id'].should == zone_attributes['id']
    end
    
    describe '#delete' do
      before do
        @connection_mock.should_receive(:call).with('domain.zone.delete', zone_id).and_return(true)
      end
      
      it "returns true" do
        subject.delete.should be_true
      end
    end
    
    describe '#update' do
      let(:zone_update_params) { {'name' => "New Name"} }
      
      before do
        @connection_mock.should_receive(:call).with('domain.zone.update', zone_id, zone_update_params).and_return(zone_attributes.merge(zone_update_params))
      end
      
      it "returns self" do
        subject.update(zone_update_params).should == subject
      end
      
      it "updates its attributes" do
        subject.update(zone_update_params)
        subject['name'].should == zone_update_params['name']
      end
    end
    
    describe '#clone' do
      before do
        @connection_mock.should_receive(:call).with('domain.zone.clone', zone_id, 0, {}).and_return(zone_attributes.merge('id' => 44, 'name' => "Gandi Zone (1)"))
      end
      
      it "returns a Zone object" do
        cloned_zone = subject.clone
        cloned_zone.should be_a(Gandi::Domain::Zone)
        cloned_zone['name'].should == "Gandi Zone (1)"
      end
    end
    
  end
end
