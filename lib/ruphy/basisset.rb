module RuPHY
	module BasisSet
		class Base
		end

		class SimpleList < Base
			def new *bases
				@bases = bases
			end

			def basis i
				@bases[i]
			end
		end
	end
end
