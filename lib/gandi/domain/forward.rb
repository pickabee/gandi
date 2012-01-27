module Gandi
  class Domain
    class Forward
      include Gandi::GandiObjectMethods
      
      attr_reader :domain, :source
      
      def initialize(domain, source, attributes = nil)
        @domain = domain
        @source = source
        @attributes = attributes || self.class.call('domain.forward.list', @domain.fqdn, {'source' => @source}).first
        raise DataError, "Forward does not exist" unless @attributes
      end
      
      #Return the destinations emails for this forward.
      def destinations
        @attributes['destinations']
      end
      
      #Delete a forward.
      #Return true.
      def delete
        self.class.call('domain.forward.delete', @domain.fqdn, @source)
      end
      
      #Update a forward.
      #Return self.
      def update(params)
        @attributes = self.class.call('domain.forward.update', @domain.fqdn, @source, params)
        return self
      end
      
      class << self
        #Create a new forward.
        #Return a Forward object.
        def create(domain, source, params)
          forward = call('domain.forward.create', domain.fqdn, source, params)
          self.new(domain, source, forward)
        end
        
        #Count forwards for a domain.
        #TODO: accept a fqdn string.
        def count(domain, opts = {})
          call('domain.forward.count', domain.fqdn, opts)
        end
        
        #List forwards for specified domain.
        #Return an array of Forward objects.
        #TODO: accept a fqdn string.
        def list(domain, opts = {})
          call('domain.forward.list', domain.fqdn, opts).map do |forward|
            self.new(domain, forward['source'], forward)
          end
        end
      end
    end
  end
end
