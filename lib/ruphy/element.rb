require 'ruphy/constants'

module RuPHY
  struct = Struct.new(:Z,:sym,:u)

  class Element < struct
    def initialize z, sym, u
      super z, sym.to_sym, u
    end

    alias amu u

    def m
      u * Constants::Da
    end

    alias me m

    def name
      sym.to_s
    end

    alias to_s name

    def inspect
      '#<%s: %s>' % [self.class, self]
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

    def structure
      @structure ||= Struct.new *to_a
    end

    protected
    def signature
      [self.class, self.Z, self.sym]
    end
  end

  Element::Struct = struct
end
