# encoding: utf-8

module Gandi
  class Contact
    TYPES = {
      0 => 'person',
      1 => 'company',
      2 => 'association',
      3 => 'organization',
      4 => 'reseller'
    }
    
    SECURITY_QUESTION_NUM_VALUES = {
      1 => "What is the name of your favorite city?",
      2 => "What is your mother’s maiden name?",
      3 => "What is your favorite food?",
      4 => "What year were you born in?",
      5 => "What is your cell phone number?",
      6 => "In what year was your Gandi account created?"
    }
    
    INFORMATION_ATTRIBUTES =  :type, :orgname, :given, :family, :streetaddr, :city, :state, :zip, :country, :phone, :fax, :mobile, 
                              :tva_number, :siren, :marque, :lang, :newsletter, :obfuscated, :whois_obfuscated, :resell, :shippingaddress, 
                              :extra_parameters
    CREATE_PARAMETERS_ATTRIBUTES =  :password, :email, 
                                    :jo_announce_page, :jo_announce_number, :jo_declaration_date, :jo_publication_date,
                                    :security_question_num, :security_question_answer
    
    attr_reader :handle, :id
    attr_accessor :type, :orgname, :given, :family, :streetaddr, :city, :state, :zip, :country, :phone, :fax, :mobile, 
                  :tva_number, :siren, :marque, :lang, :newsletter, :obfuscated, :whois_obfuscated, :resell, :shippingaddress, 
                  :extra_parameters
    
    def initialize(handle = nil, contact = nil)
      @handle = handle
      set_info_attributes(contact) if (@handle || contact)
    end
    
    #Test if a contact (defined by it’s handle) can create that domain.
    #Takes a domain hash
    #TODO allow giving a string for the domain and converting it transparently, or a domain object
    #FIXME is checking multiple domains at once possible ? (it may be according to the Gandi documentation)
    #FIXME OT&E seems to fail instead of returning an error hash (Error on object : OBJECT_APPLICATION (CAUSE_UNKNOWN) [Internal Server Error])
    def can_associate_domain(domain)
      return false unless persisted?
      self.class.call('contact.can_associate_domain', @handle, domain)
    end
    alias_method :can_associate_domain?, :can_associate_domain
    
    #Give all information on the given contact.
    #This should not be directly used as initializing the class already fetches the contact info
    def info
      raise DataError, "Cannot get informations for a new contact" unless persisted?
      self.class.call('contact.info', @handle)
    end
    
    #Check the same way as check and then update.
    #FIXME What is check ? Typo for create ?
    def update(contact)
      raise DataError, "Cannot update a new contact, use Gandi::Contact.create instead" unless persisted?
      set_info_attributes self.class.call('contact.update', @handle, contact)
    end
    
    #def type
    #  TYPES[@type]
    #end
    #
    #def type=(type_string_or_id)
    #  @type = TYPES.invert[type_string_or_id] || type_string_or_id
    #end
    
    #Returns a hash (with string keys) with the contact information attributes
    def to_hash
      INFORMATION_ATTRIBUTES.inject({}) {|h, attr|  h[attr.to_s] = send(attr); h }
    end
    
    #Returns a string containing the handle of the contact
    def to_s
      @handle || ''
    end
    
    #Returns a string containing a human-readable representation of the contact
    #TODO improve the output
    def inspect
      to_hash.to_s
    end
    
    #Returns true if the contact exists on Gandi databases
    def persisted?
      !!@handle
    end
    
    class << self
      #Should have a all optional contact dict then look if he is a person or a company and depending on that call create_person or create_company.
      #TODO filter params
      def create(contact)
        contact = call('contact.create', contact)
        self.new(contact['handle'], contact)
      end
      
      #Give all information on the contact linked to the apikey currently used.
      #Returns a hash
      def info
        call('contact.info')
      end
      
      #Test if a contact (full contact description) can be associated to the domains.
      #Takes a contact hash and a domain hash
      #TODO allow giving a string for the domain and converting it transparently, or a domain object
      #FIXME is checking multiple domains at once possible ? (it may be according to the Gandi documentation)
      #FIXME OT&E seems to fail instead of returning an error hash (Error on object : OBJECT_APPLICATION (CAUSE_UNKNOWN) [Internal Server Error])
      def can_associate(contact, domain)
        call('contact.can_associate', contact, domain)
      end
      alias_method :can_associate?, :can_associate
      
      #List all contacts linked to the connected user (it will only return contacts when the apikey belong to a reseller).
      #The array of returned contacts are mapped to contact objects, set map_contacts to false to get contact info hashes
      def list(opts = {}, map_contacts = true)
        contacts = call('contact.list', opts)
        if map_contacts
          contacts.map! do |contact|
            self.new(contact['handle'], contact)
          end
        end
        contacts
      end
      
      #Check the same way as check and then update.
      def update(handle, contact)
        contact = call('contact.update', handle, contact)
        self.new(contact['handle'], contact)
      end
      
      def call(method, *arguments) #:nodoc:
        Gandi.call(method, *arguments)
      end
    end
    
    private
    
    def set_info_attributes(infos = nil)
      infos ||= info
      @id = infos['id']
      INFORMATION_ATTRIBUTES.each do |attr|
        send("#{attr}=", infos[attr.to_s])
      end
      return infos
    end
  end
end
