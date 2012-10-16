require 'openbabel'

module RuPHY
	module Geometry
		class Molecule
			def initialize source, format = 'xyz'
				obconv = OpenBabel::OBConversion.new
				obconv.set_in_format(format) rescue raise ArgumentError, '%p is not a format registered in OpenBabel!'
				@obmol = OpenBabel::OBMol.new
				if File.exist? source
					obconv.read_file(@obmol, source)
				else
					obconv.read_string(@obmol, source)
				end
			end
		end
	end
end
