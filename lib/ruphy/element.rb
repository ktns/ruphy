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
		alias to_s name

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
end
