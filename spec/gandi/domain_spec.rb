require 'spec_helper'
require 'gandi'

describe Gandi::Domain do
  before do
    @connection_mock = double()
    ::Gandi.connection = @connection_mock
  end
end
