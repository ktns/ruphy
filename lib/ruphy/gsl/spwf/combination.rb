module RuPHY
	module GSL
		module SPWF
			class Combination
				include SPWF

				def initialize *args
					setup_params *args
				end
			end
		end
	end
end
