$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'complex'

module RuPHY
	VERSION = IO.read(File.join(File.dirname(__FILE__), %w<.. VERSION>)).chomp

	begin
		Enumerator = ::Enumerable::Enumerator
	rescue NameError
		Enumerator = ::Enumerator
	end
end

require 'ruphy/math'
require 'ruphy/orbital'
require 'ruphy/geometry'
require 'ruphy/theory'
require 'ruphy/basisset'
require 'ruphy/constants'
require 'ruphy/elements'
