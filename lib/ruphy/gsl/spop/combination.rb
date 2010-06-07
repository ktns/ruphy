module RuPHY::GSL
	module SPOP
		class Combination
			include SPOP

			def initialize *spops
				setup_params *spops
			end
		end
	end
end
