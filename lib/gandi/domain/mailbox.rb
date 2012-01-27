module Gandi
  class Domain
    class Mailbox
      include Gandi::GandiObjectMethods
      
      attr_reader :domain, :login
      
      def initialize(domain, login, attributes = nil)
        @domain = domain
        @login = login
        @attributes = attributes || info
      end
      
      #Delete a mailbox.
      #Note: the mailbox is deleted instantly.
      def delete
        self.class.call('domain.mailbox.delete', @domain.fqdn, @login)
      end
      
      #Get mailbox information for a given login created for a given domain.
      def info
        self.class.call('domain.mailbox.info', @domain.fqdn, @login)
      end
      
      #Purge a mailbox.
      #Create an operation that will delete this mailbox contents.
      #Return a Gandi::Operation object.
      def purge
        operation_hash = self.class.call('domain.mailbox.purge', @domain.fqdn, @login)
        Gandi::Operation.new(operation_hash['id'], operation_hash)
      end
      
      #Update a mailbox.
      #Returns a Gandi::Operation object.
      def update(params)
        operation_hash = self.class.call('domain.mailbox.update', @domain.fqdn, @login, params)
        Gandi::Operation.new(operation_hash['id'], operation_hash)
      end
      
      class << self
        #Create a mailbox.
        #Return a Mailbox object.
        def create(domain, login, params)
          mailbox = call('domain.mailbox.create', domain.fqdn, login, params)
          self.new(domain, login, mailbox)
        end
        
        #Count mailboxes for a given domain.
        #TODO: accept a fqdn string.
        def count(domain, opts = {})
          call('domain.mailbox.count', domain.fqdn, opts)
        end
        
        #List mailboxes for a given domain.
        #Return an array of Mailbox objects or an array of hashes.
        #Note that domain.mailbox.info will be called for each mailbox unless map_mailboxes is set to false (as the info hash returned by domain.mailbox.list does not contain the mailboxes attributes).
        #This may result in a lot of API calls if you have many registered mailboxes for your domain, so using opts to restrict results is advised (or use a raw API call).
        #TODO: accept a fqdn string.
        def list(domain, opts = {}, map_mailboxes = true)
          mailboxes = call('domain.mailbox.list', domain.fqdn, opts)
          
          if map_mailboxes
            mailboxes.map! do |mailbox|
              self.new(domain, mailbox['login'])
            end
          end
          return mailboxes
        end
      end
    end
  end
end
