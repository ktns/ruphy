begin
  require 'ruphy_libint2'

  class RuPHY::Libint2::Evaluator
    def initialize shell0, shell1, shell2, shell3
      @shells = [
        shell0, shell1, shell2, shell3
      ]
      @max_angular_momentum = @shells.map{|s|s.angular_momentum}.max
      @max_contrdepth = @shells.map{|s| s.contrdepth }.reduce(&:*)
      @Ax,@Ay,@Az = *(@A = shell0.center)
      @Bx,@By,@Bz = *(@B = shell1.center)
      @Cx,@Cy,@Cz = *(@C = shell2.center)
      @Dx,@Dy,@Dz = *(@D = shell3.center)
      @ABx,@ABy, @ABz = *(@AB = @B - @A)
      @CDx,@CDy, @CDz = *(@CD = @D - @C)
    end
  end
rescue LoadError
end
