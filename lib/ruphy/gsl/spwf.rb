module RuPHY
	module GSL
		module SPWF
			def * other
				case other
				when SPWF
					inner_product(other)
				when Numeric
					Multiplied.new(self, other)
				else
					raise TypeError
				end
			end

			def ** other
				raise ArgumentError, "expected 2, but#{other}!" unless other == 2
				self * self
			end
		end
	end 
end

require __FILE__.sub(/.rb$/,'')+'/hydrogenic.rb'
require __FILE__.sub(/.rb$/,'')+'/operated.rb'
