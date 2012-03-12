module RuPHY::GSL
	module SPOP
		class Multiplier
			include RuPHY::Digestable
			include SPOP

			def initialize real, imag = 0
				[real, imag].each do |n|
					raise TypeError,
						"Numeric expected, but #{n.class}!" unless n.kind_of?(Numeric)
				end
				@multiplier = real + imag * Complex::I
				@multiplier.freeze
				setup_params @multiplier.real, @multiplier.imag
				self.freeze
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
