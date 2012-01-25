module Gandi
  class Domain
    module Nameservers
      #Returns the domains nameservers.
      def nameservers
        @attributes['nameservers']
      end
      
      #Define the nameservers for a given domain. Uses the API call domain.nameservers.set
      #Returns a Gandi::Operation object.
      def nameservers=(nameservers)
        operation_hash = self.class.call('domain.nameservers.set', @fqdn, nameservers)
        Gandi::Operation.new(operation_hash['id'], operation_hash)
      end
    end
  end
end
