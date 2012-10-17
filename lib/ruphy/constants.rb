module RuPHY
	module Constants
		module Predefined
			module SI
				Da   = 1.66053892173e-27
				Me   = 9.109382616e-31
				Bohr = 0.5291772109217e-10
			end

			Da = SI::Da / SI::Me
			Angstrom = 1e-10 / SI::Bohr
		end

		module ConstMissing
			def const_missing name
				const_set(name, Predefined.const_get(name))
			end
		end

		extend ConstMissing

		def self.included klass
			klass.extend ConstMissing
		end
	end
end
