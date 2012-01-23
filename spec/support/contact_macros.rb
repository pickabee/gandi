module ContactMacros
  def contact_information_attributes_hash(ext_attrs = {})
    {"city"=>"Aix", 
      "given"=>"John", 
      "family"=>"Doe", 
      "zip"=>"13100", 
      "country"=>"FR", 
      "streetaddr"=>"1 Rue du Pont", 
      "phone"=>"+33.400000000", 
      "password"=>"password", 
      "type"=>0, 
      "email"=>"johndoe@pickabee.com"}.merge(ext_attrs)
  end
end

RSpec.configure do |config|
  config.include ContactMacros
end
