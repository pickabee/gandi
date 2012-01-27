module Gandi
  class Domain
    class Host
      include Gandi::GandiObjectMethods
      
      #The hostname of the Host
      attr_reader :hostname
      
      def initialize(hostname, attributes = nil)
        @hostname = hostname
        @attributes = attributes || info
      end
      
      #Delete a host.
      #Returns a Gandi::Operation object.
      def delete
        operation_hash = self.class.call('domain.host.delete', @hostname)
        Gandi::Operation.new(operation_hash['id'], operation_hash)
      end
      
      #Display host information for a given domain.
      def info
        self.class.call('domain.host.info', @hostname)
      end
      
      #Return the host IP adresses.
      def ips
        @attributes['ips']
      end
      
      #Update a host.
      #Return a Gandi::Operation object.
      def update(ips)
        operation_hash = self.class.call('domain.host.update', @hostname, ips)
        Gandi::Operation.new(operation_hash['id'], operation_hash)
      end
      
      class << self
        #Create a host.
        #Returns a Gandi::Operation object.
        def create(hostname, ips)
          operation_hash = call('domain.host.create', hostname, ips)
          Gandi::Operation.new(operation_hash['id'], operation_hash)
        end
        
        #Count the glue records / hosts of a domain.
        #TODO: accept a Domain object.
        def count(fqdn, opts = {})
          call('domain.host.count', fqdn, opts)
        end
        
        #List the glue records / hosts for a given domain.
        #Return an array of Host objects.
        #TODO: accept a Domain object.
        def list(fqdn, opts = {})
          call('domain.host.list', fqdn, opts).map do |host|
            self.new(host['name'], host)
          end
        end
      end
    end
  end
end
