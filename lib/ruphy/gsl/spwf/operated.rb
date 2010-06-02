module RuPHY
	module GSL
		module SPWF
			class Operated
				include SPWF

				def initialize spop, spwf
					raise TypeError,
						"SPOP expected, but #{spop.class}!" unless spop.kind_of?(SPOP)
					raise TypeError,
						"SPWF expected, but #{spwf.class}!" unless spwf.kind_of?(SPWF)
					setup_params(spop, spwf)
				end
			end

			class Multiplied
				include SPWF

				def initialize spwf, real, imag = nil
					if real.kind_of?(Complex)
						raise TypeError,
							"Don't specify complex number and imaginary part together!" if imag
						imag = real.image
						real = real.real
					elsif imag.nil?
						imag = 0
					end
					[real, imag].each do |n|
						raise TypeError,
							"Numeric expected, but #{n.class}!" unless n.kind_of?(Numeric)
					end
					@multiplier = Complex.new(real, imag)
					@spwf = spwf
					setup_params spwf, real, imag
				end

				def to_a
					[self.class, @spwf, @multiplier]
				end
				protected :to_a

				def hash
					to_a.hash
				end

				def eql? other
					to_a.eql? other.to_a rescue false
				end

				def == other
					to_a == other.to_a rescue false
				end

				def * other
					if other.kind_of? Numeric
						Multiplied.new(@spwf, @multiplier * other)
					else
						super
					end
				end
			end
		end
	end
end
