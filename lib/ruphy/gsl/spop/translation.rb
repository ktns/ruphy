module RuPHY::GSL
	module SPOP
		class Translation
			include SPOP

			def initialize dx, dy, dz
				setup_params dx, dy, dz
			end
		end
	end
end
