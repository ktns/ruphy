module RuPHY
  class AO
    def initialize *args
      raise NotImplementedError
    end

    private_class_method :new
  end
end

require 'ruphy/ao/gaussian'
