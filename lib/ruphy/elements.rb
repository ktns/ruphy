require 'ruphy/element'
require 'ruphy/elements/predefined'

module RuPHY
  class ElementsClass < Hash
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
      self
    end

    def structures
      ::Hash[*
        map do |k,v|
          [k,v.structure]
        end.flatten
      ]
    end

    private
    def entry elem
      case elem
      when Element
      when Array, Struct
        elem = Element.new(*elem)
      else
        raise TypeError, "Expected #{Element} or #{Array} or #{Struct}, but received #{elem.class}!"
      end
      self[elem.sym] = self[elem.Z] = self[elem.sym.to_s] = self[elem.Z.to_s] = elem
    end

  end

  Elements = ElementsClass.new.extend(ElementData::PreDefined)
end
