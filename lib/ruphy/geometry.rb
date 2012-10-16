require 'openbabel'
require 'matrix'
require 'ruphy/constants'

module RuPHY
	module Geometry
		class Molecule
			include RuPHY::Constants
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

			def each_atom
				if block_given?
					iter = @obmol.begin_atoms
					atom = @obmol.begin_atom(iter)
					begin
						yield atom
					end while atom = @obmol.next_atom(iter)
				else
					Enumerator.new(self, :each_atom)
				end
			end

			def nuclear_replusion_energy
				each_atom.to_a.combination(2).inject(0) do |e, (a1, a2)|
					v1, v2 = [a1,a2].map{|a|Vector[a.x,a.y,a.z]}
					r = (v1-v2).r * Angstrom
					e + a1.get_atomic_num * a2.get_atomic_num / r
				end
			end
		end
	end
end
