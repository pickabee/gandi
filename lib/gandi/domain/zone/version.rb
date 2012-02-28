module Gandi
  class Domain
    class Zone
      class Version
        extend Gandi::Connector
        
        class << self
          #Delete a specific version.
          #Return true.
          def delete(zone_id, version_id)
            call('domain.zone.version.delete', zone_id, version_id)
          end
          
          #New version from another version. This will duplicate the version’s records.
          #Note that cloned records will have new identifiers.
          #Return the created version number.
          #NOTE: This method is called new in the XML-RPC, API, and has been named create here to avoid conflicts with Ruby's initialize method
          def create(zone_id, version_id = 0)
            call('domain.zone.version.new', zone_id, version_id)
          end
          
          #Sets the active zone version.
          #Return true.
          def set(zone_id, version_id)
            call('domain.zone.version.set', zone_id, version_id)
          end
        end
        
      end
    end
  end
end
