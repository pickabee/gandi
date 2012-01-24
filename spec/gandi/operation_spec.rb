require 'spec_helper'
require 'gandi'

describe Gandi::Operation do
  before do
    @connection_mock = double()
    ::Gandi.connection = @connection_mock
  end
  
  context "a new instance" do
    before do
      @id = '123'
      @attributes = operation_information_attributes_hash('id' => '123')
      @connection_mock.should_receive(:call).with('operation.info', @id).and_return(@attributes)
    end
    subject { Gandi::Operation.new(@id) }
    
    its(:id) { should == @id }
    
    it "can read its attributes" do
      subject.to_hash.should == @attributes
      subject['step'].should == @attributes['step']
    end
    
    it "can fetch its informations" do
      @connection_mock.should_receive(:call).with('operation.info', @id).and_return(@attributes)
      subject.info['step'].should == @attributes['step']
    end
    
    describe '#cancel' do
      context "successful" do
        before do
          @connection_mock.should_receive(:call).with('operation.cancel', @id).and_return(true)
          @cancel_result = subject.cancel
        end
        
        specify { @cancel_result.should be_true }
        specify { subject['step'].should == 'CANCEL' }
      end
      
      #Can this really happen ?
      context "failed" do
        before do
          @connection_mock.should_receive(:call).with('operation.cancel', @id).and_return(false)
          @cancel_result = subject.cancel
        end
        
        specify { @cancel_result.should be_false }
        specify { subject['step'].should == @attributes['step'] }
      end
    end
  end
  
  describe '.count' do
    it "returns an integer" do
      @connection_mock.should_receive(:call).with('operation.count', {}).and_return(42)
      Gandi::Operation.count.should == 42
    end
  end
  
  describe '.list' do
    it "returns an array of operations" do
      @operations_array = [operation_information_attributes_hash('id' => '123'), operation_information_attributes_hash('id' => '456')]
      @connection_mock.should_receive(:call).with('operation.list', {}).and_return(@operations_array)
      
      operations = Gandi::Operation.list
      
      operations.length.should == @operations_array.length
      operations.first.should be_a(Gandi::Operation)
      operations.first.id.should == @operations_array.first['id']
    end
  end
end
