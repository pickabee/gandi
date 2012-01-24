require 'spec_helper'
require 'gandi'

describe Gandi::Domain::Tld do
  before do
    @connection_mock = double()
    ::Gandi.connection = @connection_mock
  end
  
  describe '.list' do
    it "returns a hash" do
      @connection_mock.should_receive(:call).with('domain.tld.list').and_return(domain_tld_list)
      Gandi::Domain::Tld.list.should == domain_tld_list
    end
  end
  
  describe '.region' do
    it "returns an array" do
      @connection_mock.should_receive(:call).with('domain.tld.region').and_return(domain_tld_regions)
      Gandi::Domain::Tld.region.should == domain_tld_regions
    end
  end
end
