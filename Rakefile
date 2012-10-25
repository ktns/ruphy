# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
jeweler_tasks = Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "ruphy"
  gem.homepage = "http://github.com/ktns/ruphy"
  gem.license = "GPLv3"
  gem.summary = %Q{TODO: one-line summary of your gem}
  gem.description = %Q{TODO: longer description of your gem}
  gem.email = "ktns.87@gmail.com"
  gem.authors = ["Katsuhiko Nishimra"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

if RUBY_VERSION < '1.9'
	RSpec::Core::RakeTask.new(:rcov) do |spec|
		spec.pattern = 'spec/**/*_spec.rb'
		spec.rcov = true
	end
else
	RSpec::Core::RakeTask.new(:simplecov) do |spec|
		spec.pattern = 'spec/**/*_spec.rb'
		ENV['SIMPLECOV']='true'
	end
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruphy #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

CLEAN << 'gem_graph.png' 
