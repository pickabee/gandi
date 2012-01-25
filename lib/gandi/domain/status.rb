module Gandi
  class Domain
    module Status
      #Lock a domain, set the ‘clientTransferProhibited’ status flag.
      #Returns a Gandi::Operation object.
      def lock
        operation_hash = self.class.call('domain.status.lock', @fqdn)
        Gandi::Operation.new(operation_hash['id'], operation_hash)
      end
      
      #Unlock a domain, unset the ‘clientTransferProhibited’ status flag.
      #Returns a Gandi::Operation object.
      def unlock
        operation_hash = self.class.call('domain.status.unlock', @fqdn)
        Gandi::Operation.new(operation_hash['id'], operation_hash)
      end
    end
  end
end
