require 'yaml'
require 'ruphy/constants'

module RuPHY
  struct = Struct.new(:Z,:sym,:u)

  class Element < struct
    def initialize z, sym, u
      super z, sym.to_sym, u
    end

    alias amu u

    alias z Z
    alias atomic_number Z

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
      @structure ||= Struct.new(*to_a)
    end

    # yaml encoding definition
    def to_yaml(opts = {})
      if defined?(YAML::ENGINE) and YAML::ENGINE.yamler == 'psych'
        super
      else
        #syck encoding definition
        YAML.quick_emit(hash, opts) do |out|
          out.scalar("x-private:#{self.class}", z.to_s, :plain)
        end
      end
    end

    if defined?(YAML::ENGINE) and YAML::ENGINE.yamler == 'psych'
      self.yaml_tag(YAML.tagurize("#{self}"))
    else
      YAML::add_private_type(self.to_s) do |type, value|
        RuPHY::Elements[value]
      end
    end

    # psych yaml encoding definition
    def encode_with coder
      coder.represent_scalar(YAML.tagurize(self.class.to_s), z.to_s)
    end

    # psych yaml decoding definition
    def init_with coder
      initialize_copy RuPHY::Elements[coder.scalar]
    end

    protected
    def signature
      [self.class, self.Z, self.sym]
    end
  end

  Element::Struct = struct
end
