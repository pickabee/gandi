module Gandi
  class Domain
    module Contacts
      #Returns an hash of contacts, keys being the type of contact and values Gandi::Contact objects.
      #TODO make the contact mapping optional.
      def contacts
        @attributes['contacts'].inject({}) { |h, contact| h[contact.first] = Gandi::Contact.new(contact.last['handle']); h }
      end
      
      #Change domain’s contact. Uses the API call domain.contacts.set
      #Returns a Gandi::Operation object.
      #NOTE: you cannot change the owner or reseller contacts.
      #FIXME: is it possible to return the operation object and not the contacts hash passed as a param?
      #TODO accept Gandi::Contact objects as values for the hash.
      def contacts=(contacts)
        operation_hash = self.class.call('domain.contacts.set', @fqdn, contacts)
        Gandi::Operation.new(operation_hash['id'], operation_hash)
      end
    end
  end
end
