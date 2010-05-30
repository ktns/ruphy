begin
	require 'spec'
rescue LoadError
	require 'rubygems' unless ENV['NO_RUBYGEMS']
	gem 'rspec'
	require 'spec'
end

def random_coordinate
	return (1-a=rand())/a, rand() * Math::PI/2, rand() * Math::PI
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'ruphy'
