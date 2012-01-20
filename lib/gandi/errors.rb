module Gandi
  class DataError < ArgumentError
  end
  
  class ServerError < RuntimeError
  end
  
  class NoMethodError < ::NoMethodError
  end
end
