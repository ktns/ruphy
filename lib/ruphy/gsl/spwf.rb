module RuPHY
	module GSL
		module SPWF
			def + other
				raise TypeError, "#{SPWF} expected, but #{other.class}!" unless other.kind_of?(SPWF)
				Combination.new(self, other)
			end

			def - other
				self + (-other)
			end

			def * other
				case other
				when SPWF
					inner_product(other)
				when Numeric
					Operated.new(SPOP::Multiplier.new(other), self)
				else
					raise TypeError
				end
			end

			def -@
				self * -1
			end

			def ** other
				raise ArgumentError, "expected 2, but#{other}!" unless other == 2
				self * self
			end
		end
	end
end

require __FILE__.sub(/.rb$/,'')+'/combination.rb'
require __FILE__.sub(/.rb$/,'')+'/hydrogenic.rb'
require __FILE__.sub(/.rb$/,'')+'/operated.rb'
