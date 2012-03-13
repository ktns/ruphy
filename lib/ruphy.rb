$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'complex'

module RuPHY
	VERSION = '0.0.1'

	# internal utility function
	# called from inside of ruphy_gsl.so
	def self.complex x, y
		if v = [x,y].find{|v|not v.class <= Numeric}
			raise TypeError, "Numeric expected, but `#{v.class}'"
		end
		Complex(x,y)
	end

end

begin
	require 'ruphy_gsl'
rescue LoadError
	$: << File.join(File.dirname(__FILE__), *%w<.. ext ruphy_gsl>)
	require 'ruphy_gsl'
end

require 'ruphy/digestable.rb'
require 'ruphy/gsl/error.rb'
require 'ruphy/gsl/spwf.rb'
require 'ruphy/gsl/spop.rb'
require 'ruphy/geometry'
require 'ruphy/theory'
