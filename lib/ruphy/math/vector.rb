require 'matrix'

module RuPHY::VectorInclude
  def r2
    inject(0.0){|r2, x| r2 + x**2}
  end
end

class Vector
  include RuPHY::VectorInclude
end
