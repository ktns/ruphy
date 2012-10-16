require 'openbabel'

module RuPHY
	module Geometry
		class Molecule
			def initialize source, format = 'xyz'
				obconv = OpenBabel::OBConversion.new
				obconv.set_in_format(format) or raise ArgumentError, '%p is not a format registered in OpenBabel!' % format
				@obmol = OpenBabel::OBMol.new
				if File.exist? source
					obconv.read_file(@obmol, source)
				else
					obconv.read_string(@obmol, source)
				end
			end

			def size
				@obmol.num_atoms
			end
		end
	end
end
