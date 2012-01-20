require 'bundler/setup'
require 'rake'
require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['-c', '-f progress', '-r ./spec/spec_helper.rb', '--backtrace']
  t.pattern = 'spec/**/*_spec.rb'
end

task :default  => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Gandirb"
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('README*', 'CHANGELOG', 'LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options << '--line-numbers'
  rdoc.options << '--charset=UTF-8'
end
