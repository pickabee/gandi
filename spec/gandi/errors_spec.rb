require 'spec_helper'
require 'gandi/errors'

describe Gandi::DataError do
  it "should define a custom error class" do
    Gandi::DataError.ancestors.should include(ArgumentError)
  end
end
describe Gandi::ServerError do
  it "should define a custom error class" do
    Gandi::ServerError.ancestors.should include(RuntimeError)
  end
end
describe Gandi::NoMethodError do
  it "should define a custom error class" do
    Gandi::NoMethodError.ancestors.should include(NoMethodError)
  end
end
