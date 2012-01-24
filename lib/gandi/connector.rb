module Gandi
  module Connector
    def call(method, *arguments) #:nodoc:
      Gandi.call(method, *arguments)
    end
  end
end
