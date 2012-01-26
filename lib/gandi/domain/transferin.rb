module Gandi
  class Domain
    module Transferin
      #Transfer a domain. Uses the API call domain.transferin.proceed
      #Returns a Gandi::Operation object.
      #NOTE: this may be untestable in OT&E
      def transferin(fqdn, params)
        operation_hash = call('domain.transferin.proceed', fqdn, params)
        Gandi::Operation.new(operation_hash['id'], operation_hash)
      end
    end
  end
end
