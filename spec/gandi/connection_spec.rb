require 'spec_helper'
require 'gandi/connection'
require 'gandi/errors'

describe Gandi::Connection do
  describe "#new" do
    it "connects using apikey and url" do
      gandi_connection = Gandi::Connection.new('apikey', 'http://fakedomain.tld/')
      gandi_connection.instance_variable_get('@handler').should be_a(XMLRPC::Client)
      gandi_connection.instance_variable_get('@handler').instance_variable_get('@host').should == 'fakedomain.tld'
    end
    
    it "fails when setting a nil apikey" do
      lambda { Gandi::Connection.new(nil, nil) }.should raise_error(Gandi::DataError)
    end
  end
  
  context "an instance" do
    subject { Gandi::Connection.new('apikey', 'http://fakedomain.tld/') }
    
    its(:url) { should == 'http://fakedomain.tld/' }
    its(:apikey) { should == 'apikey' }
    
    it "can call methods and transmit them to the handler" do
      subject.instance_variable_get('@handler').should_receive(:call).once.with('method.name', 'apikey', 'arg1', 'arg2').and_return('result value')
      subject.call('method.name', 'arg1', 'arg2').should == 'result value'
    end
    
    it "maps xml-rpc 5xxxxx errors to Gandi errors" do
      subject.instance_variable_get('@handler').should_receive(:call).once.with('contact.list', 'apikey', 'AB123-GANDI').and_raise(XMLRPC::FaultException.new('516150', "Error on object : OBJECT_CONTACT (CAUSE_NORIGHT) [You aren't allowed to read that contact]"))
      lambda { subject.call('contact.list', 'AB123-GANDI') }.should raise_error(Gandi::DataError)
    end
    
    it "maps xml-rpc errors with faultCode 1 to Gandi error" do
      subject.instance_variable_get('@handler').should_receive(:call).once.with('unknownmethod', 'apikey').and_raise(XMLRPC::FaultException.new('1', 'Method "unknownmethod" is not supported'))
      lambda { subject.call('unknownmethod') }.should raise_error(Gandi::NoMethodError)
    end
  end
end
