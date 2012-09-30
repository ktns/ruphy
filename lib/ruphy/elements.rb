require 'ruphy/constants'

module RuPHY
	class Element
		def initialize z, sym, m
			@Z, @sym, @m = z, sym.to_sym, m / Constants::Da
		end

		attr_reader :Z, :sym, :m

		def name
			@sym.to_s
		end
	end

	Elements = {}

	class << Elements
		def [] key
			if key? key
				super
			else
				elem = Element.new(*get_elem_data(key))
				self[elem.sym] = self[elem.Z] = elem
			end
		end
	end
end
