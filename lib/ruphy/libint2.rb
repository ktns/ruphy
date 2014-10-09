begin
  require 'ruphy_libint2'

  class RuPHY::Libint2::Evaluator
    def initialize shell1, shell2, shell3, shell4
      @shells = [
        shell1, shell2, shell3, shell4
      ]
      @max_angular_momentum = @shells.map{|s|s.angular_momentum}.max
      @max_contrdepth = @shells.map{|s| s.contrdepth }.reduce(&:*)
    end
  end
rescue LoadError
end
