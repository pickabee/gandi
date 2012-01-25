module Gandi
  module GandiObjectMethods
    def self.included(base)
      base.extend Gandi::Connector
    end
    
    #Returns a hash (with string keys) with the object information attributes.
    def to_hash
      @attributes.dup
    end
    
    #Returns a string containing a human-readable representation of the object.
    #TODO improve the output.
    def inspect
      @attributes.inspect
    end
    
    #Returns an attribute value.
    def [](attribute)
      @attributes[attribute.to_s]
    end
  end
end
