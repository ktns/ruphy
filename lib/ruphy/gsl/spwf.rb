module RuPHY
	module GSL
		module SPWF
			def * other
				case other
				when SPWF
					inner_product(other)
				else
					raise TypeError
				end
			end
		end
	end 
end

require __FILE__.sub(/.rb$/,'')+'/hydrogenic.rb'
require __FILE__.sub(/.rb$/,'')+'/operated.rb'
