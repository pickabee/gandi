require 'spec_helper'
require 'gandi'

describe Gandi::Domain::Zone::Version do
  let(:zone_id) { 42 }
  
  before do
    @connection_mock = double()
    ::Gandi.connection = @connection_mock
  end
  
  describe '.delete' do
    let(:version_id) { 42 }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.version.delete', zone_id, version_id).and_return(true)
    end
    
    it "returns true" do
      Gandi::Domain::Zone::Version.delete(zone_id, version_id).should be_true
    end
  end
  
  describe '.create' do
    before do
      @connection_mock.should_receive(:call).with('domain.zone.version.new', zone_id, 0).and_return(11)
    end
    
    it "returns the new version" do
      Gandi::Domain::Zone::Version.create(zone_id).should == 11
    end
  end
  
  describe '.set' do
    let(:version_id) { 23 }
    
    before do
      @connection_mock.should_receive(:call).with('domain.zone.version.set', zone_id, version_id).and_return(true)
    end
    
    it "returns true" do
      Gandi::Domain::Zone::Version.set(zone_id, version_id).should be_true
    end
  end
  
end
