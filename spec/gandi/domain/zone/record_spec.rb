require 'spec_helper'
require 'gandi'

describe Gandi::Domain::Zone::Record do
  let(:zone_id) { 42 }
  let(:version_id) { 7 }
  
  before do
    @connection_mock = double()
    ::Gandi.connection = @connection_mock
  end
  
  describe '.add' do
    let(:record_creation_attributes) { domain_zone_record_creation_attributes }
    let(:record_attributes) { record_creation_attributes.merge('id' => 42) }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.record.add', zone_id, version_id, record_creation_attributes).and_return(record_attributes)
    end
    
    it "returns a record hash" do
      record = Gandi::Domain::Zone::Record.add(zone_id, version_id, record_creation_attributes)
      record.should == record_attributes
    end
  end
  
  describe '.count' do
    before do
      @connection_mock.should_receive(:call).with('domain.zone.record.count', zone_id, version_id).and_return(55)
    end
    
    it "returns an integer" do
      Gandi::Domain::Zone::Record.count(zone_id, version_id).should == 55
    end
  end
  
  describe '.delete' do
    before do
      @connection_mock.should_receive(:call).with('domain.zone.record.delete', zone_id, version_id, {}).and_return(12)
    end
    
    it "returns an integer" do
      Gandi::Domain::Zone::Record.delete(zone_id, version_id).should == 12
    end
  end
  
  describe '.list' do
    let(:records_list) { [domain_zone_record_attributes, domain_zone_record_attributes('id' => 2), domain_zone_record_attributes('id' => 3)] }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.record.list', zone_id, version_id, {}).and_return(records_list)
    end
    
    it "returns an array of hashes" do
      Gandi::Domain::Zone::Record.list(zone_id, version_id).should == records_list
    end
  end
  
  describe '.set' do
    let(:records_creation_list) { [domain_zone_record_creation_attributes, domain_zone_record_creation_attributes] }
    let(:records_list) { [domain_zone_record_attributes, domain_zone_record_attributes('id' => 2)] }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.record.set', zone_id, version_id, records_creation_list).and_return(records_list)
    end
    
    it "returns a domain hash" do
      records_hash = Gandi::Domain::Zone::Record.set(zone_id, version_id, records_creation_list)
      records_hash.should == records_list
    end
  end
  
end
