module RuPHY
	module GSL
		module SPWF
			class Operated
				def initialize spop, spwf
					raise TypeError,
						"SPOP expected, but #{spop.class}!" unless spop.kind_of?(SPOP)
					raise TypeError,
						"SPWF expected, but #{spwf.class}!" unless spwf.kind_of?(SPWF)
					setup_params(spop, spwf)
				end
			end

			class Multiplied
				def initialize spwf, real, imag = nil
					if real.kind_of?(Complex)
						raise TypeError,
							"Don't specify complex number and imaginary part together!" if imag
						imag = real.image
						real = real.real
					end
					[real, imag].each do |n|
						raise TypeError,
							"Numeric expected, but #{n.class}!" unless n.kind_of?(Numeric)
					end
					setup_params spwf, real, imag
				end
			end
		end
	end
end
