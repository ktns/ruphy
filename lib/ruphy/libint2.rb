begin
  require 'ruphy_libint2'

  class RuPHY::Libint2::Evaluator
    def initialize shell0, l0, shell1, l1, shell2, l2, shell3, l3
      @shell0, @shell1, @shell2, @shell3 = @shells = [
        shell0, shell1, shell2, shell3
      ]
      @l0, @l1, @l2, @l3 = @l = [l0, l1, l2, l3]
      @shells.zip(@l).each do |shell, l|
        raise ArgumentError, "%p does not contain %d in azimuthal_quantum_numbers" % [shell, l] unless
        shell.azimuthal_quantum_numbers.include? l
      end
      reorder_shells

      @total_azimuthal_quantum_number = @l.reduce(&:+)
      @max_azimuthal_quantum_number = @l.max
      @max_contrdepth = @shells.map{|s| s.contrdepth }.reduce(&:*)
      @Ax,@Ay,@Az = *(@A = @shell0.center)
      @Bx,@By,@Bz = *(@B = @shell1.center)
      @Cx,@Cy,@Cz = *(@C = @shell2.center)
      @Dx,@Dy,@Dz = *(@D = @shell3.center)
      @ABx,@ABy, @ABz = *(@AB = @B - @A)
      @CDx,@CDy, @CDz = *(@CD = @D - @C)
    end

    attr_reader :max_azimuthal_quantum_number, :total_azimuthal_quantum_number, :original_shell_order, :results

    def each_primitive_shell
      @shell0.each_primitive_shell(@l0) do |c0,z0|
        @shell1.each_primitive_shell(@l1) do |c1,z1|
          @shell2.each_primitive_shell(@l2) do |c2,z2|
            @shell3.each_primitive_shell(@l3) do |c3,z3|
              yield c0*c1*c2*c3,z0,z1,z2,z3
            end
          end
        end
      end
    end

    def each_primitive_shell_with_index
      enum_for(:each_primitive_shell).each_with_index do |(*arg),i|
        yield i, *arg
      end
    end

    @@table = {}

    def self.[] shell0, l0, shell1, l1, shell2, l2, shell3, l3
      key = [[shell0, l0], [shell1, l1], [shell2, l2], [shell3, l3]].sort_by(&:hash)
      @@table[key]||= self.new(shell0, l0, shell1, l1, shell2, l2, shell3, l3)
    end
  end
rescue LoadError
end
