# encoding: utf-8

module Gandi
  class Contact
    include Gandi::GandiObjectMethods
    
    #Contact types mapping
    TYPES = {
      0 => 'person',
      1 => 'company',
      2 => 'association',
      3 => 'organization',
      4 => 'reseller'
    }
    
    #Security questions mapping
    SECURITY_QUESTION_NUM_VALUES = {
      1 => "What is the name of your favorite city?",
      2 => "What is your mother’s maiden name?",
      3 => "What is your favorite food?",
      4 => "What year were you born in?",
      5 => "What is your cell phone number?",
      6 => "In what year was your Gandi account created?"
    }
    
    #Settable contact attributes (ie. not the id or handle)
    WRITABLE_ATTRIBUTES =  :type, :orgname, :given, :family, :streetaddr, :city, :state, :zip, :country, :phone, :fax, :mobile, 
                              :tva_number, :siren, :marque, :lang, :newsletter, :obfuscated, :whois_obfuscated, :resell, :shippingaddress, 
                              :extra_parameters
    
    #Additional attributes used when creating an account
    CREATE_PARAMETERS_ATTRIBUTES =  :password, :email, 
                                    :jo_announce_page, :jo_announce_number, :jo_declaration_date, :jo_publication_date,
                                    :security_question_num, :security_question_answer
    
    #Attributes returned when calling contact.info or creating/updating a contact
    INFORMATION_ATTRIBUTES = WRITABLE_ATTRIBUTES + [:id]
    
    attr_reader :handle
    
    #A new instance of Contact.
    #Takes a Gandi handle and/or a contact hash with string keys.
    #When providing only a handle the contact info will be fetched from the API.
    def initialize(handle = nil, contact = nil)
      @handle = handle
      @attributes = {}
      self.attributes=(contact) if (@handle || contact)
    end
    
    #Test if a contact (defined by its handle) can create that domain.
    #Takes a domain hash.
    #TODO allow giving a string for the domain and converting it transparently, or a domain object.
    #FIXME is checking multiple domains at once possible ? (it may be according to the Gandi documentation).
    #FIXME OT&E seems to fail instead of returning an error hash (Error on object : OBJECT_APPLICATION (CAUSE_UNKNOWN) [Internal Server Error]).
    def can_associate_domain(domain)
      return false unless persisted?
      self.class.call('contact.can_associate_domain', @handle, domain)
    end
    
    #TODO make this method return a boolean
    alias_method :can_associate_domain?, :can_associate_domain
    
    #Give all information on the given contact.
    #This should not be directly used as initializing the class already fetches the contact info.
    def info
      raise DataError, "Cannot get informations for a new contact" unless persisted?
      self.class.call('contact.info', @handle)
    end
    
    #Check the same way as check and then update.
    #FIXME What is check ? Typo for create ?
    def update(contact)
      raise DataError, "Cannot update a new contact, use Gandi::Contact.create instead" unless persisted?
      self.attributes = self.class.call('contact.update', @handle, contact)
    end
    
    (WRITABLE_ATTRIBUTES - [:type]).each do |attr|
      define_method(attr) do
        @attributes[attr.to_s]
      end
      
      define_method("#{attr}=") do |value|
        @attributes[attr.to_s] = value
      end
    end
    
    #Returns the contact unique identifier.
    def id
      @attributes['id']
    end
    
    #Returns the contact type string.
    def type
      TYPES[@attributes['type']]
    end
    
    #Sets the contact type (provided with a type string or id).
    def type=(type_string_or_id)
      @attributes['type'] = TYPES.invert[type_string_or_id] || type_string_or_id
    end
    
    #Sets a contact attribute value.
    def []=(attribute, value)
      raise DataError, "Attribute #{attribute} is read-only" unless WRITABLE_ATTRIBUTES.include?(attribute.to_sym)
      @attributes[attribute.to_s] = value
    end
    
    #Returns a string containing the handle of the contact.
    def to_s
      @handle || ''
    end
    
    #Returns true if the contact exists on Gandi databases.
    def persisted?
      !!@handle
    end
    
    class << self
      #Should have a all optional contact dict then look if he is a person or a company and depending on that call create_person or create_company.
      #Returns a contact object.
      #TODO filter params.
      def create(contact)
        contact = call('contact.create', contact)
        self.new(contact['handle'], contact)
      end
      
      #Give all information on the contact linked to the apikey currently used.
      #Returns a hash.
      def info
        call('contact.info')
      end
      
      #Test if a contact (full contact description) can be associated to the domains.
      #Takes a contact hash and a domain hash.
      #TODO allow giving a string for the domain and converting it transparently, or a domain object.
      #FIXME is checking multiple domains at once possible ? (it may be according to the Gandi documentation).
      #FIXME OT&E seems to fail instead of returning an error hash (Error on object : OBJECT_APPLICATION (CAUSE_UNKNOWN) [Internal Server Error]).
      def can_associate(contact, domain)
        call('contact.can_associate', contact, domain)
      end
      
      #TODO make this method return a boolean
      alias_method :can_associate?, :can_associate
      
      #List all contacts linked to the connected user (it will only return contacts when the apikey belong to a reseller).
      #The array of returned contacts are mapped to contact objects, set map_contacts to false to get contact info hashes.
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
      #Returns a contact object.
      #TODO filter params.
      def update(handle, contact)
        contact = call('contact.update', handle, contact)
        self.new(contact['handle'], contact)
      end
    end
    
    private
    
    def attributes=(contact = nil)
      contact_attributes = contact || info
      @attributes = contact_attributes.reject {|k,v| !INFORMATION_ATTRIBUTES.include?(k.to_sym) }
      @attributes['handle'] = @handle || contact_attributes['handle']
      return @attributes
    end
  end
end
