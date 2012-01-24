require 'gandi/version'
require 'gandi/errors'
require 'gandi/connection'
require 'gandi/connector'
require 'gandi/operation'
require 'gandi/contact'

module Gandi
  #Production URL
  URL = "https://rpc.gandi.net/xmlrpc/"
  
  #OT&E URL
  TEST_URL = "https://rpc.ote.gandi.net/xmlrpc/"
  
  class << self
    #The 24-character API key used for authentication.
    attr_reader :apikey
    
    #Sets the apikey for the Gandi connection.
    #Changing it will reset the connection.
    def apikey=(apikey)
      @apikey = apikey
      @connection = nil
    end
    
    #The URL for the Gandi connection.
    def url
      @url || Gandi::TEST_URL
    end
    
    #Sets the URL for the Gandi connection.
    #Changing it will reset the connection.
    def url=(url)
      @url = url
      @connection = nil
    end
    
    #A Gandi::Connection object set using the provided apikey and url.
    #This object can be overriden for testing purposes.
    #Note that the connection object is reset if the apikey or url is changed.
    def connection
      @connection ||= Gandi::Connection.new(apikey, url)
    end
    
    attr_writer :connection

    #Calls a Gandi XML-RPC method, transparently providing the apikey.
    def call(method, *arguments)
      connection.call(method, *arguments)
    end
    
    #Returns the API version from Gandi.
    def api_version
      Gandi.call('version.info')['api_version']
    end
  end
end
