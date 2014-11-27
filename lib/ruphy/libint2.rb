begin
  require 'ruphy_libint2'

  module RuPHY::Libint2
    class Evaluator
      def initialize shell0, l0, shell1, l1, shell2, l2, shell3, l3
        shell0, l0, shell1, l1, shell2, l2, shell3, l3 = self.class.reorder_shells shell0, l0, shell1, l1, shell2, l2, shell3, l3

        @shell0, @shell1, @shell2, @shell3 = @shells = [
          shell0, shell1, shell2, shell3
        ]
        @l0, @l1, @l2, @l3 = @l = [l0, l1, l2, l3]
        @shells.zip(@l).each do |shell, l|
          raise ArgumentError, "%p does not contain %d in azimuthal_quantum_numbers" % [shell, l] unless
          shell.azimuthal_quantum_numbers.include? l
        end

        @total_azimuthal_quantum_number = @l.reduce(&:+)
        @max_azimuthal_quantum_number = @l.max
        @max_contrdepth = @shells.map{|s| s.contrdepth }.reduce(&:*)

        raise ArgumentError, "The max azimuthal quantum number is larger than LIBINT_MAX_AM (%d > %d)" %
          [@max_azimuthal_quantum_number, MaxAM] if @max_azimuthal_quantum_number > MaxAM

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

      def get_result_for_aos ao0, ao1, ao2, ao3
        aos = [ao0, ao1, ao2, ao3].sort_by! do |ao|
          @shells.index(ao.shell) or raise ArgumentError,
            "`%p'.shell is not in the evaluator!" % ao
        end
        momenta = aos.map(&:momenta)

        return aos.reduce(results[momenta]) do |n, ao|
          n * ao.normalization_factor * ao.shell_ao_normalization_factor_ratio
        end
      end

      @@table = {}

      def self.each_equivalent_shell_order shell0, shell1, shell2, shell3
        return enum_for(:each_equivalent_shell_order, shell0, shell1, shell2, shell3) unless block_given?
        [[shell0, shell1], [shell2, shell3]].permutation(2) do |ss1, ss2|
          ss1.permutation(2) do |s0, s1|
            ss2.permutation(2) do |s2, s3|
              yield s0, s1, s2, s3
            end
          end
        end
      end

      def self.[] shell0, l0, shell1, l1, shell2, l2, shell3, l3
        each_equivalent_shell_order [shell0, l0], [shell1, l1], [shell2, l2], [shell3, l3] do |*args|
          evaluator = @@table[args.flatten] and return evaluator
        end
        return @@table[[shell0, l0, shell1, l1, shell2, l2, shell3, l3]] =
          self.new(shell0, l0, shell1, l1, shell2, l2, shell3, l3)
      end

      def self.clear
        @@table.clear and nil
      end
    end

    # Mix-in module for RuPHY::AO::Gaussian::Contracted::Product
    module ContractedProduct
      # Reimplement electron_repulsion using Libint2
      def electron_repulsion other
        aos = [*self.aos, *other.aos]
        shells = aos.map(&:shell)
        ls = aos.map{|ao| ao.angular_momentum }
        evaluator = Evaluator[*shells.zip(ls).flatten(1)]
        evaluator.initialize_evaluator
        evaluator.evaluate
        evaluator.get_result_for_aos(*aos)
      end

      # Override all methods
      def self.append_features mod
        methods = instance_methods(false) & mod.instance_methods(false)
        methods.each do |method|
          mod.send(:remove_method, method)
        end
        super
      end
    end

    unless $0 =~ /rspec/
      RuPHY::AO::Gaussian::Contracted::Product.include ContractedProduct
    end
  end
rescue LoadError
end
