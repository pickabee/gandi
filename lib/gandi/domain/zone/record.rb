module Gandi
  class Domain
    class Zone
      class Record
        extend Gandi::Connector
        
        class << self
          #Add a new record to zone/version.
          #Return a Record hash.
          def add(zone_id, version_id, record)
            call('domain.zone.record.add', zone_id, version_id, record)
          end
          
          #Count number of records for a given zone/version.
          def count(zone_id, version_id)
            call('domain.zone.record.count', zone_id, version_id)
          end
          
          #Remove some records from a zone/version, filters are the same as for list.
          #Return the number of records deleted.
          def delete(zone_id, version_id, filters = {})
            call('domain.zone.record.delete', zone_id, version_id, filters)
          end
          
          #List a zone’s records, with an optional filter.
          #Return an array of record hashes.
          def list(zone_id, version_id, filters = {})
            call('domain.zone.record.list', zone_id, version_id, filters = {})
          end
          
          #Sets the records for a zone/version.
          #Return an array of record hashes.
          def set(zone_id, version_id, records)
            call('domain.zone.record.set', zone_id, version_id, records)
          end
        end
        
      end
    end
  end
end
