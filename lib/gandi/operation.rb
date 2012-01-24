# encoding: utf-8

module Gandi
  class Operation
    attr_reader :id
    
    def initialize(operation_id, information_attributes = nil)
      @id = operation_id
      @info = information_attributes || info
    end
    
    #Return some attributes of a operation visible by this account.
    def info
      self.class.call('operation.info', @id)
    end
    
    #Set the step of an operation to CANCEL.
    def cancel
      result = self.class.call('operation.cancel', @id)
      @info['step'] = 'CANCEL' if result
      return result
    end
    
    #Returns a hash (with string keys) with the operation information attributes.
    def to_hash
      @info
    end
    
    #Returns an operation attribute value.
    def [](attribute)
      to_hash[attribute]
    end
    
    class << self
      #Count operations visible by this account.
      def count(opts = {})
        call('operation.count', opts)
      end
      
      #List operations done by this account.
      #The array of returned operations are mapped to Operation objects unless map_operations is set to false.
      def list(opts = {}, map_operations = true)
        operations = call('operation.list', opts)
        if map_operations
          operations.map! do |operation|
            self.new(operation['id'], operation)
          end
        end
        operations
      end
      
      def call(method, *arguments) #:nodoc:
        Gandi.call(method, *arguments)
      end
    end
  end
end