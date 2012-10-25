require 'ruphy/element'
require 'ruphy/elements/predefined'

module RuPHY
	Elements = {}

	class << Elements
		def [] key
			if key? key
				super
			else
				entry get_elem_data(key)
			end
		end

		def symbols
			load_all
			return values.map(&:sym)
		end

		def load_all
			get_all_data do |data|
				entry data
			end
		end

		private
		def entry elem
			case elem
			when Element
			when Array
				elem = Element.new(*elem)
			else
				raise TypeError
			end
			self[elem.sym] = self[elem.Z] = self[elem.sym.to_s] = self[elem.Z.to_s] = elem
		end

		include ElementData::PreDefined
	end
end
