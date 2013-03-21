require 'ruphy/constants'

module RuPHY
  struct = Struct.new(:Z,:sym,:m)

  class Element < struct
    def initialize z, sym, m
      super z, sym.to_sym, m * Constants::Da
    end

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
      @structure ||= Struct.new self.Z, sym, m / Constants::Da
    end

    protected
    def signature
      [self.class, self.Z, self.sym]
    end
  end

  Element::Struct = struct
end
