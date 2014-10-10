begin
  require 'ruphy_libint2'

  class RuPHY::Libint2::Evaluator
    def initialize shell0, shell1, shell2, shell3
      @shell0, @shell1, @shell2, @shell3 = @shells = [
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

    attr_reader :max_angular_momentum

    def each_primitive_shell
      @shell0.each_primitive_shell do |c0,z0|
        @shell1.each_primitive_shell do |c1,z1|
          @shell2.each_primitive_shell do |c2,z2|
            @shell3.each_primitive_shell do |c3,z3|
              yield c0*c1*c2*c3,z0,z1,z2,z3
            end
          end
        end
      end
    end
  end
rescue LoadError
end
