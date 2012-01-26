module DomainMacros
  def domain_information_attributes_hash(ext_attrs = {})
    year, month, day, hour, min, sec = 1970, 1, 1, 1, 1, 1
    {
      "status"=>["clientTransferProhibited"], 
      "date_renew_end"=> XMLRPC::DateTime.new(year, month, day, hour, min, sec), 
      "date_pending_delete_end"=> XMLRPC::DateTime.new(year, month, day, hour, min, sec), 
      "zone_id"=> 1, 
      "tags"=>[], 
      "date_updated"=> XMLRPC::DateTime.new(year, month, day, hour, min, sec), 
      "date_delete"=> XMLRPC::DateTime.new(year, month, day, hour, min, sec), 
      "contacts"=>{
        "owner"=>{"handle"=>"FLN123-GANDI", "id"=>1}, 
        "admin"=>{"handle"=>"FLN123-GANDI", "id"=>1}, 
        "bill"=>{"handle"=>"FLN123-GANDI", "id"=>1}, 
        "tech"=>{"handle"=>"FLN123-GANDI", "id"=>1}, 
        "reseller"=>{"handle"=>"FLN123-GANDI", "id"=>1}
      },
      "date_registry_end"=> XMLRPC::DateTime.new(year, month, day, hour, min, sec), 
      "nameservers"=>["a.dns.gandi.net", "b.dns.gandi.net", "c.dns.gandi.net"], 
      "authinfo"=>"aaa", 
      "date_registry_creation"=> XMLRPC::DateTime.new(year, month, day, hour, min, sec), 
      "date_renew_begin"=> XMLRPC::DateTime.new(year, month, day, hour, min, sec), 
      "date_hold_end" => XMLRPC::DateTime.new(year, month, day, hour, min, sec), 
      "date_created"=> XMLRPC::DateTime.new(year, month, day, hour, min, sec), 
      "date_restore_end"=>XMLRPC::DateTime.new(year, month, day, hour, min, sec), 
      "id"=>1, 
      "tld"=>"com"
      #"fqdn"=>"domain.com",
    }.merge(ext_attrs)
  end
  
  def domain_creation_operation_hash(ext_attrs = {})
    ext_attrs = {"type" => 'domain_create',
      'id' => 0,
      "session_id"=>0,
      "eta"=>0,
      'params' => {"domain"=>"fqdn", "bill"=>"FLN123-GANDI", "reseller"=>"FLN123-GANDI", "admin"=>"FLN123-GANDI", "pre_migration"=>true, "source_ip"=>"127.0.0.1", "ns"=>["gandi.net"], "duration"=>1, "source_client"=>"", "backend-version"=>3, "owner"=>"FLN123-GANDI", "tech"=>"FLN123-GANDI", "param_type"=>"domain", "auth_id"=>0},
      "last_error" => "0",
      'infos' => {"product_action"=>"create", "product_type"=>"domain", "product_name"=>".tld", "extras"=>{}, "label"=>"fqdn", "id"=>"", "quantity"=>""},
      "step"=>"BILL"
      }.merge(ext_attrs)
    operation_information_attributes_hash(ext_attrs)
  end
  
  def domain_renew_spec(ext_attrs = {})
    {
      'duration' => 1,
      'current_year' => Date.today.year
    }.merge(ext_attrs)
  end
  
  def domain_renewal_operation_hash(ext_attrs = {})
    ext_attrs = {"type" => 'domain_renew',
      'id' => 0,
      "session_id"=>0,
      "eta"=>0,
      'params' => {"domain"=>"fqdn", "bill"=>"FLN123-GANDI", "reseller"=>"FLN123-GANDI", "admin"=>"FLN123-GANDI", "pre_migration"=>true, "source_ip"=>"127.0.0.1", "ns"=>["gandi.net"], "duration"=>1, "source_client"=>"", "backend-version"=>3, "owner"=>"FLN123-GANDI", "tech"=>"FLN123-GANDI", "param_type"=>"domain", "auth_id"=>0},
      "last_error" => "0",
      'infos' => {"product_action"=>"renew", "product_type"=>"domain", "product_name"=>".tld", "extras"=>{}, "label"=>"fqdn", "id"=>"", "quantity"=>""},
      "step"=>"BILL"
      }.merge(ext_attrs)
    operation_information_attributes_hash(ext_attrs)
  end

  def domain_tld_regions
    {"generic"=>["aero", "biz", "com", "coop", "info", "mobi", "name", "net", "org", "pro", "tel", "travel"], "europe"=>["at", "be", "ch", "co.uk", "com.de", "de", "de.com", "es", "eu", "eu.com", "fr", "gb.com", "gb.net", "gr.com", "hu.com", "im", "it", "li", "lt", "lu", "me", "me.uk", "nl", "no", "no.com", "nu", "org.uk", "pl", "pt", "ru", "ru.com", "se", "se.com", "se.net", "uk.com", "uk.net"], "america"=>["ag", "ar.com", "br.com", "bz", "ca", "cc", "co", "gs", "gy", "hn", "ht", "la", "lc", "qc.com", "us", "us.com", "us.org", "uy.com", "vc"], "africa"=>["mu", "re", "sc", "za.com"], "asia"=>["ae.org", "af", "asia", "cn", "cn.com", "cx", "fm", "hk", "jp", "jpn.com", "ki", "kr.com", "mn", "nf", "sa.com", "sb", "tl", "tv", "tw", "ws"]}
  end

  def domain_tld_list
    [{"region"=>"asia", "id"=>87, "name"=>"ae.org"}, {"region"=>"generic", "id"=>41, "name"=>"aero"}, {"region"=>"asia", "id"=>92, "name"=>"af"}, {"region"=>"america", "id"=>95, "name"=>"ag"}, {"region"=>"america", "id"=>77, "name"=>"ar.com"}, {"region"=>"asia", "id"=>21, "name"=>"asia"}, {"region"=>"europe", "id"=>23, "name"=>"at"}, {"region"=>"europe", "id"=>7, "name"=>"be"}, {"region"=>"generic", "id"=>5, "name"=>"biz"}, {"region"=>"america", "id"=>76, "name"=>"br.com"}, {"region"=>"america", "id"=>46, "name"=>"bz"}, {"region"=>"america", "id"=>115, "name"=>"ca"}, {"region"=>"america", "id"=>18, "name"=>"cc"}, {"region"=>"europe", "id"=>14, "name"=>"ch"}, {"region"=>"asia", "id"=>25, "name"=>"cn"}, {"region"=>"asia", "id"=>70, "name"=>"cn.com"}, {"region"=>"america", "id"=>88, "name"=>"co"}, {"region"=>"europe", "id"=>13, "name"=>"co.uk"}, {"region"=>"generic", "id"=>1, "name"=>"com"}, {"region"=>"europe", "id"=>138, "name"=>"com.de"}, {"region"=>"generic", "id"=>113, "name"=>"coop"}, {"region"=>"asia", "id"=>56, "name"=>"cx"}, {"region"=>"europe", "id"=>22, "name"=>"de"}, {"region"=>"europe", "id"=>82, "name"=>"de.com"}, {"region"=>"europe", "id"=>32, "name"=>"es"}, {"region"=>"europe", "id"=>9, "name"=>"eu"}, {"region"=>"europe", "id"=>64, "name"=>"eu.com"}, {"region"=>"asia", "id"=>61, "name"=>"fm"}, {"region"=>"europe", "id"=>8, "name"=>"fr"}, {"region"=>"europe", "id"=>66, "name"=>"gb.com"}, {"region"=>"europe", "id"=>67, "name"=>"gb.net"}, {"region"=>"europe", "id"=>91, "name"=>"gr.com"}, {"region"=>"america", "id"=>52, "name"=>"gs"}, {"region"=>"america", "id"=>110, "name"=>"gy"}, {"region"=>"asia", "id"=>62, "name"=>"hk"}, {"region"=>"america", "id"=>49, "name"=>"hn"}, {"region"=>"america", "id"=>51, "name"=>"ht"}, {"region"=>"europe", "id"=>85, "name"=>"hu.com"}, {"region"=>"europe", "id"=>33, "name"=>"im"}, {"region"=>"generic", "id"=>4, "name"=>"info"}, {"region"=>"europe", "id"=>20, "name"=>"it"}, {"region"=>"asia", "id"=>39, "name"=>"jp"}, {"region"=>"asia", "id"=>71, "name"=>"jpn.com"}, {"region"=>"asia", "id"=>94, "name"=>"ki"}, {"region"=>"asia", "id"=>72, "name"=>"kr.com"}, {"region"=>"america", "id"=>69, "name"=>"la"}, {"region"=>"america", "id"=>96, "name"=>"lc"}, {"region"=>"europe", "id"=>15, "name"=>"li"}, {"region"=>"europe", "id"=>63, "name"=>"lt"}, {"region"=>"europe", "id"=>29, "name"=>"lu"}, {"region"=>"europe", "id"=>28, "name"=>"me"}, {"region"=>"europe", "id"=>38, "name"=>"me.uk"}, {"region"=>"asia", "id"=>47, "name"=>"mn"}, {"region"=>"generic", "id"=>12, "name"=>"mobi"}, {"region"=>"africa", "id"=>55, "name"=>"mu"}, {"region"=>"generic", "id"=>6, "name"=>"name"}, {"region"=>"generic", "id"=>2, "name"=>"net"}, {"region"=>"asia", "id"=>93, "name"=>"nf"}, {"region"=>"europe", "id"=>37, "name"=>"nl"}, {"region"=>"europe", "id"=>90, "name"=>"no"}, {"region"=>"europe", "id"=>86, "name"=>"no.com"}, {"region"=>"europe", "id"=>19, "name"=>"nu"}, {"region"=>"generic", "id"=>3, "name"=>"org"}, {"region"=>"europe", "id"=>16, "name"=>"org.uk"}, {"region"=>"europe", "id"=>30, "name"=>"pl"}, {"region"=>"generic", "id"=>31, "name"=>"pro"}, {"region"=>"europe", "id"=>42, "name"=>"pt"}, {"region"=>"america", "id"=>79, "name"=>"qc.com"}, {"region"=>"africa", "id"=>11, "name"=>"re"}, {"region"=>"europe", "id"=>36, "name"=>"ru"}, {"region"=>"europe", "id"=>78, "name"=>"ru.com"}, {"region"=>"asia", "id"=>73, "name"=>"sa.com"}, {"region"=>"asia", "id"=>53, "name"=>"sb"}, {"region"=>"africa", "id"=>48, "name"=>"sc"}, {"region"=>"europe", "id"=>40, "name"=>"se"}, {"region"=>"europe", "id"=>83, "name"=>"se.com"}, {"region"=>"europe", "id"=>84, "name"=>"se.net"}, {"region"=>"generic", "id"=>35, "name"=>"tel"}, {"region"=>"asia", "id"=>54, "name"=>"tl"}, {"region"=>"generic", "id"=>112, "name"=>"travel"}, {"region"=>"asia", "id"=>17, "name"=>"tv"}, {"region"=>"asia", "id"=>27, "name"=>"tw"}, {"region"=>"europe", "id"=>65, "name"=>"uk.com"}, {"region"=>"europe", "id"=>68, "name"=>"uk.net"}, {"region"=>"america", "id"=>10, "name"=>"us"}, {"region"=>"america", "id"=>75, "name"=>"us.com"}, {"region"=>"america", "id"=>109, "name"=>"us.org"}, {"region"=>"america", "id"=>80, "name"=>"uy.com"}, {"region"=>"america", "id"=>50, "name"=>"vc"}, {"region"=>"asia", "id"=>103, "name"=>"ws"}, {"region"=>"africa", "id"=>81, "name"=>"za.com"}]
  end
  
  def domain_host_attributes_hash(ext_attrs = {})
    {"ips"=>["1.2.3.4"], "name"=>"", 'domain' => ''}.merge(ext_attrs)
  end
end

RSpec.configure do |config|
  config.include DomainMacros
end
