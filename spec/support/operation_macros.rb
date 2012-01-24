module OperationMacros
  def operation_information_attributes_hash(ext_attrs = {})
    year, month, day, hour, min, sec = 1970, 1, 1, 1, 1, 1
    { 
      "source" => 'HA0-GANDI',
      "date_created" => XMLRPC::DateTime.new(year, month, day, hour, min, sec),
      "date_updated" => XMLRPC::DateTime.new(year, month, day, hour, min, sec),
      "date_start" => '',
      "step" => 'WAIT'
      #"type" => 'domain_create'
      #"session_id"=>0,
      #"eta"=>0
      #params => {}
      #"last_error" => "0"
      #infos => {}
    }.merge(ext_attrs)
  end
end

RSpec.configure do |config|
  config.include OperationMacros
end
