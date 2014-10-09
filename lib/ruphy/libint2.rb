begin
  require 'ruphy_libint2'

  class RuPHY::Libint2::Evaluator
    def initialize shell1, shell2, shell3, shell4
      @max_angular_momentum = [
        shell1, shell2, shell3, shell4
      ].map{|s|s.angular_momentum}.max
    end
  end
rescue LoadError
end
