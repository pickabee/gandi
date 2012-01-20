require 'spec_helper'
require 'gandi'

describe Gandi do
  it "should have a settable url defaulting to the test url" do
    Gandi.url.should == Gandi::TEST_URL
    Gandi.url = 'settable url'
    Gandi.url.should == 'settable url'
  end
  
  it "should have a settable apikey" do
    Gandi.apikey.should == nil
    Gandi.apikey = 'settable apikey'
    Gandi.apikey.should == 'settable apikey'
  end
  
  it "should have a settable connection" do
    Gandi.apikey = 'settable apikey'
    Gandi.url = 'settable url'
    Gandi::Connection.should_receive(:new).with('settable apikey', 'settable url').once.and_return('connection object')
    Gandi.connection.should == 'connection object'
    
    Gandi.connection = 'settable connection'
    Gandi.connection.should == 'settable connection'
  end
  
  context "with a connection" do
    before do
      @connection = double()
      Gandi.connection = @connection
    end
    
    describe "#call" do
      it "passes the called method to the connection" do
        @connection.should_receive(:call).with('called.method', 'arg1', 'arg2').once.and_return('returned value')
        Gandi.call('called.method', 'arg1', 'arg2').should == 'returned value'
      end
    end
    
    describe "#api_version" do
      it "returns a string containing the current version" do
        @connection.should_receive(:call).with('version.info').once.and_return({"api_version"=>'X.Y'})
        Gandi.api_version.should == 'X.Y'
      end
    end
    
    it "resets the connection when changing the url" do
      Gandi.url = Gandi::TEST_URL
      Gandi.connection.should_not == @connection
    end
    
    it "resets the connection when changing the apikey" do
      Gandi.apikey = 'apikey'
      Gandi.connection.should_not == @connection
    end
  end
end
