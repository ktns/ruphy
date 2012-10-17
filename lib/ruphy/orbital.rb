module RuPHY
	class Orbital
		def initialize *args
			raise NotImplementedError
		end

		private_class_method :new
	end
end

require 'ruphy/orbital/gaussian'
