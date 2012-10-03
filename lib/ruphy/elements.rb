require 'ruphy/constants'

module RuPHY
	class Element
		def initialize z, sym, m
			@Z, @sym, @m = z, sym.to_sym, m * Constants::Da
		end

		attr_reader :Z, :sym, :m

		def name
			@sym.to_s
		end

		def hash
			signature.hash
		end

		def eql? other
			signature.eql? other.signature rescue false
		end

		def == other
			signature == other.signature rescue false
		end

		protected
		def signature
			[self.class, @Z, @sym]
		end
	end

	Elements = {}

	class << Elements
		def [] key
			if key? key
				super
			else
				elem = Element.new(*get_elem_data(key))
				entry elem
			end
		end

		private
		def entry elem
			self[elem.sym] = self[elem.Z] = self[elem.sym.to_s] = self[elem.Z.to_s] = elem
		end
	end
end
