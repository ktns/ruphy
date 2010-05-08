begin
	require 'spec'
rescue LoadError
	require 'rubygems' unless ENV['NO_RUBYGEMS']
	require 'spec'
end
begin
	require 'spec/rake/spectask'
rescue LoadError
	puts <<-EOS
To use rspec for testing you must install rspec gem:
		gem install rspec
	EOS
	exit(0)
end

desc "Run the specs under spec/models"
Spec::Rake::SpecTask.new do |t|
	t.spec_opts = ['--options', "spec/spec.opts"]
	t.spec_files = FileList['spec/**/*_spec.rb']
end

namespace :spec do
	Spec::Rake::SpecTask.new('rcov') do |t|
		t.spec_files = FileList['spec/**/*_spec.rb']
		t.rcov = true
		t.spec_opts = %w<-c>
		t.rcov_opts = Gem.path.collect do |p|
			['-x',p]
		end.flatten.concat(['-x', '^spec/'])
	end

	task :rcov => :compile
end
