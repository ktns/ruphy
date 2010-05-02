$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module RuPHY
	VERSION = '0.0.1'
end

begin
	require "ruphy_gsl.so"
rescue LoadError
end
require 'ruphy/gsl/spwf.rb'
