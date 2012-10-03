require 'matrix'

require 'ruphy'
require 'ruphy/geometry/reader/xyz'
module RuPHY
	module Geometry
		class Molecule
			def initialize *args
				if File.exist? fname=args.first
					case File.extname(fname)
					when /xyz/i
						extend Reader::XYZ
						read fname
						return
					else
						raise ArgumentError
					end
				end

				raise ArgumentError
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
					@pos = Vector[x,y,z]
				end
			end
		end
	end
end
