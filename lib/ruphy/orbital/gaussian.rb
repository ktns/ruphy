module RuPHY
	class Orbital
		class Gaussian < Orbital
			def initialize *args
				raise NotImplementedError
			end

			class Primitive < Orbital
				def initialize *args
					raise NotImplementedError
				end
			end
		end
	end
end
