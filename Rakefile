# encoding: utf-8

$:.unshift File.join(File.dirname(__FILE__),'lib')

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
  gem.files.exclude '.document'
  gem.files.exclude '.rspec'
  gem.files.exclude '.travis.yml'
  gem.files.exclude 'Gemfile*'
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
    spec.rcov_opts = %w<--exclude gems,spec>
  end
else
  RSpec::Core::RakeTask.new(:simplecov) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
    ENV['SIMPLECOV']='true'
  end
end

CLEAN << 'coverage'

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruphy #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

CLEAN << 'rdoc'
CLEAN << 'gem_graph.png' 

# Racc task

RaccSources = FileList['lib/**/*.y']
RaccOutputs = RaccSources.ext('rb')
task :racc => RaccOutputs
task :spec => RaccOutputs

CLEAN << RaccOutputs

rule '.rb' => '.y' do |t|
  opts = []
  opts << '-g' if ENV['RACC_DEBUG']
  sh "racc #{opts.join(' ')} #{t.source} -o #{t.name}"
end

# Gaussian94 basisset file to yml file
Gaussian94Sources = FileList['lib/**/*.gbs']
Gaussian94Outputs = Gaussian94Sources.ext('.yml')

task :gbs2yml => Gaussian94Outputs
task :spec => Gaussian94Outputs

CLOBBER << Gaussian94Outputs

rule '.yml' => ['.gbs', 'lib/ruphy/basisset/parser/gaussian94.rb'] do |t|
  require 'yaml'
  require 'ruphy'
  require 'ruphy/basisset/parser/gaussian94'
  puts 'Parsing `%s\' as Gaussian94 basisset definition file' % t.source
  name = File.basename(t.source, '.gbs')
  bs = RuPHY::BasisSet::Parser::Gaussian94.new.parse(IO.read(t.source), :name => name)
  puts 'Dumping basisset definition to `%s\'' % t.name
  begin
    File.open t.name, 'w' do |yml|
      yml.puts bs.to_yaml
    end
  ensure
    rm_f t.name if $!
  end
end

# prof task
ProfSources = FileList['prof/*_prof']
ProfOutputs = ProfSources.sub(/$/,'.out')
CLEAN << ProfOutputs

task :prof => :profile
task :profile => ProfOutputs

rule %r"prof/.*_prof.out$" => lambda{|n|n.ext('')} do |t|
  system "ruby-prof -p call_tree -f '#{t.name}' '#{t.source}'"
end
