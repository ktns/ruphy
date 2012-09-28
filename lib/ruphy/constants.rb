module RuPHY
	module Constants
		module Predefined
			module SI
				Da = 1.66053892173e-27
				Me = 9.109382616e-31
			end

			Da = SI::Da / SI::Me
		end

		def self.const_missing name
			const_set(name, Predefined.const_get(name))
		end
	end
end
