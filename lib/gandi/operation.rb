# encoding: utf-8

module Gandi
  class Operation
    include Gandi::GandiObjectMethods
    
    attr_reader :id
    
    def initialize(operation_id, information_attributes = nil)
      @id = operation_id
      @attributes = information_attributes || info
    end
    
    #Return some attributes of a operation visible by this account.
    def info
      self.class.call('operation.info', @id)
    end
    
    ##TODO utility method to check if the operation has finished running
    #def finished?
    #end
    
    ##TODO use ActiveSupport::StringInquirer
    #def step
    #end
    
    #Set the step of an operation to CANCEL.
    def cancel
      result = self.class.call('operation.cancel', @id)
      @attributes['step'] = 'CANCEL' if result
      return result
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
    end
  end
end