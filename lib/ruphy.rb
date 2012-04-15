$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'complex'

module RuPHY
	VERSION = '0.0.1'

end

require 'ruphy/digestable.rb'
require 'ruphy/orbital'
require 'ruphy/geometry'
require 'ruphy/theory'
require 'ruphy/basisset'
