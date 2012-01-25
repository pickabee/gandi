module Gandi
  class Domain
    module Transferin
      #Transfer a domain. Uses the API call domain.transferin.proceed
      #Returns a Gandi::Operation object.
      def transferin(params)
        operation_hash = self.class.call('domain.transferin.proceed', @fqdn, params)
        Gandi::Operation.new(operation_hash['id'], operation_hash)
      end
    end
  end
end
