module Gandi
  class Domain
    class Zone
      include Gandi::GandiObjectMethods
      
      #The zone_id of the Zone
      attr_reader :id
      
      def initialize(attributes)
        set_attributes attributes
      end
      
      #Clone a zone and its records from a given version.
      #Return the created Zone.
      def clone(version_id = 0, params = {})
        self.class.new(self.class.clone(@id, version_id, params))
      end
      
      #Delete the zone.
      #Return true.
      def delete
        self.class.delete(@id)
      end
      
      #Update a zone.
      #Return self.
      def update(params)
        set_attributes self.class.update(@id, params)
        self
      end
      
      class << self
        #Create a zone.
        #Returns a Gandi::Domain::Zone object.
        def create(params)
          new(call('domain.zone.create', params))
        end
        
        #Return the zone identified by its zone_id
        def find(zone_id)
          new(call('domain.zone.info', zone_id))
        end
        
        #Fetch the zone information for the zone identified by its zone_id.
        #Return a hash.
        def info(zone_id)
          call('domain.zone.info', zone_id)
        end
        
        #Count the zones.
        def count(opts = {})
          call('domain.zone.count', opts)
        end
        
        #List zones.
        #Return an array of hashes.
        def list(opts = {})
          call('domain.zone.list', opts)
        end
        
        #Clone a zone and its records from a given version.
        #This create a new zone that will only contain this version.
        #Note that cloned records will have new identifiers.
        #Return a hash with the new zone information.
        def clone(zone_id, version_id = 0, params = {})
          call('domain.zone.clone', zone_id, version_id, params)
        end
        
        #Deletes a zone if not linked to any domain
        #Warning: this also deletes all versions and records.
        #Return true.
        def delete(zone_id)
          call('domain.zone.delete', zone_id)
        end
        
        #Change the current zone of a domain.
        #Return a hash with the modified domain
        def set(domain, zone_id)
          call('domain.zone.set', domain, zone_id)
        end
        
        #Update an existing zone.
        #Return the updated information hash.
        def update(zone_id, params)
          call('domain.zone.update', zone_id, params)
        end
      end
      
      private
      
      def set_attributes(attributes)
        @attributes = attributes
        @id = attributes['id']
      end
    end
  end
end
