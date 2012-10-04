require 'matrix'

require 'ruphy'
require 'ruphy/geometry/reader/xyz'
module RuPHY
	module Geometry
		class Molecule
			def initialize io, type
				extend Reader::Readers[type.to_sym]
				read io
			end

			class Atom
				def initialize elem, x,y,z
					case elem
					when Element
						@elem = elem
					when Integer
						@elem = Elements[elem]
					else
						@elem = Elements[elem.to_sym]
					end
					raise ArgumentError unless @elem.kind_of?(Element)
					@pos = Vector[x,y,z]
				end
			end
		end
	end
end
