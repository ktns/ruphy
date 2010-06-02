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

				def to_a
					[self.class, @spwf, @spop]
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
			end
		end
	end
end
