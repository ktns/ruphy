module RuPHY::GSL
	module SPOP
		class Multiplier
			include RuPHY::Digestable
			include SPOP

			def initialize real, imag = nil
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
				setup_params real, imag
			end

			attr_reader :multiplier

			def digest_args
				[Multiplier, @multiplier]
			end

			def == other
				self.class == other.class and @multiplier == other.multiplier
			end

			def eql? other
				self.class == other.class and @multiplier.eql? other.multiplier
			end

			def -@
				Multiplier.new(-@multiplier)
			end

			def * other
				case other
				when SPWF
					super
				when Multiplier
					Multiplier.new(self.multiplier * other.multiplier)
				else
					Multiplier.new(self.multiplier * other)
				end
			end

			def / other
				case other
				when Multiplier
					Multiplier.new(self.multiplier / other.multiplier)
				else
					Multiplier.new(self.multiplier / other)
				end
			end

			def ** other
				case other
				when Multiplier
					Multiplier.new(self.multiplier ** other.multiplier)
				else
					Multiplier.new(self.multiplier ** other)
				end
			end
		end
	end
end
