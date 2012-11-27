require 'ruphy/element'
require 'ruphy/elements/predefined'

module RuPHY
  Elements = {}

  class << Elements
    def [] key
      if key? key
        super
      else
        case data = get_elem_data(key)
        when Element
          elem = data
        when Array
          elem = Element.new(*data)
        end
        entry elem
      end
    end

    private
    def entry elem
      self[elem.sym] = self[elem.Z] = self[elem.sym.to_s] = self[elem.Z.to_s] = elem
    end

    include ElementData::PreDefined
  end
end
