$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'complex'

module RuPHY
	VERSION = '0.0.1'

	def self.complex x, y
		if v = [x,y].find{|v|not v.class <= Numeric}
			raise TypeError, "Numeric expected, but `#{v.class}'"
		end
		Complex(x,y)
	end
end

begin
	require "ruphy_gsl.so"
rescue LoadError
end
require 'ruphy/gsl/spwf.rb'
