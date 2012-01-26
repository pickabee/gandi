# encoding: utf-8

require 'gandi/domain/tld'
require 'gandi/domain/contacts'
require 'gandi/domain/status'
require 'gandi/domain/transferin'
require 'gandi/domain/nameservers'

module Gandi
  class Domain
    include Gandi::GandiObjectMethods
    include Gandi::Domain::Contacts
    include Gandi::Domain::Status
    extend Gandi::Domain::Transferin
    include Gandi::Domain::Nameservers
    
    attr_reader :fqdn
    
    def initialize(fqdn)
      @fqdn = fqdn
      @attributes = info
    end
    
    #get domain information.
    def info
      self.class.call('domain.info', @fqdn)
    end
    
    #Renew a domain.
    def renew(params)
      operation_hash = self.class.call('domain.renew', @fqdn, params)
      Gandi::Operation.new(operation_hash['id'], operation_hash)
    end
    
    class << self
      #Check the availability of some domain names.
      def available(fqdns)
        call('domain.available', fqdns)
      end
      
      #Count domains visible by this account.
      def count(filters = {})
        call('domain.count', filters)
      end
      
      #List operations done by this account.
      #Note that domain.info will be called for each domain (as the info hash return by domain.list is missing some informations).
      #This may result in a lot of API calls if you have many registered domains for your contact, so using opts to restrict results is advised (or use a raw API call).
      def list(opts = {})
        call('domain.list', opts).map do |domain|
          self.new(domain['fqdn'])
        end
      end
      
      #Create a domain with the given information.
      #Returns a Gandi::Domain object.
      def create(fqdn, params)
        operation_hash = call('domain.create', fqdn, params)
        Gandi::Operation.new(operation_hash['id'], operation_hash)
      end
    end
  end
end
