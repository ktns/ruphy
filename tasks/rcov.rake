begin
	require 'rspec'
rescue LoadError
	require 'rubygems' unless ENV['NO_RUBYGEMS']
	require 'rspec'
end
begin
	require 'rspec/core/rake_task'
rescue LoadError
	puts <<-EOS
To use rspec for testing you must install rspec gem:
		gem install rspec
	EOS
	exit(0)
end

namespace :spec do
	desc 'generate coverage information from specs'
	RSpec::Core::RakeTask.new('rcov') do |t|
		t.rcov = true
		t.rcov_opts = Gem.path.collect do |p|
			['-x',p]
		end.flatten.concat(['-x', '^spec/'])
	end

	task :rcov => :compile
end
