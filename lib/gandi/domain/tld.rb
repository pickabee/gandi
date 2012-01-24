module Gandi
  class Domain
    class Tld
      extend Gandi::Connector
      
      #List all tld available in API.
      def self.list
        call('domain.tld.list')
      end
      
      #List all tld by region, available in API.
      def self.region
        call('domain.tld.region')
      end
    end
  end
end
