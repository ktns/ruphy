module RuPHY
	module GSL
		module SPWF
			class Operated
				include Digestable
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

				def digest_args
					to_a
				end

				def eql? other
					to_a.eql? other.to_a rescue false
				end

				def == other
					to_a == other.to_a rescue false
				end

				def to_s
					'%s * %s' % [@spop, @spwf]
				end

				def inspect
					'#<%s: %s * %s>' % [self.class, *[@spop, @spwf].map(&:inspect)]
				end
			end
		end
	end
end
