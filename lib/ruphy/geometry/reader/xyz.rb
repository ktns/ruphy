require 'ruphy/geometry/molecule'

module RuPHY::Geometry
	module Reader
		module XYZ 
			def read io
				raise NotImplementedError
			end
		end

		Readers ||= {} rescue Readers = {}
		Readers[:xyz] = Readers[:XYZ] = XYZ
	end

	def self.read_xyzfile file
		File.open file do |io|
			Molecule.new(io, :xyz)
		end
	end
end
