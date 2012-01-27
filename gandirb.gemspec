# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'gandi/version'

Gem::Specification.new do |s|
  s.name = "gandirb"
  s.version = Gandi::VERSION
  s.platform = Gem::Platform::RUBY

  s.authors = ["Pickabee"]
  s.email = ""
  s.homepage = "http://github.com/pickabee/gandi"
  s.summary = %q{Ruby library for using the Gandi XML-RPC API}
  s.description = <<-EOL
  A Ruby library for using the Gandi XML-RPC API.
  At the moment support is planned for the Domain, Contact and Operation APIs only, but Hosting and Catalog APIs support may be added in the future.
  EOL
  s.rubyforge_project = "gandirb"

  s.date = Date.today.strftime('%Y-%m-%d')

  s.files = Dir["CHANGELOG", "LICENSE", "README.rdoc", "USAGE.rdoc", "Gemfile", "Rakefile", "gandirb.gemspec", "{lib}/**/*.rb"]
  s.test_files = Dir["{spec}/**/*.rb"]
  s.rdoc_options = ["--line-numbers", "--charset=UTF-8", "--title", "Gandirb", "--main", "README.rdoc"]
  s.extra_rdoc_files = %w[USAGE.rdoc CHANGELOG LICENSE]
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rspec', '>= 2.8'
end
