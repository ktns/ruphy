module RuPHY
  module BasisSet
    module LCAO
      class Gaussian
        include BasisSet
        class Shell
          CartAngularMomentumBasis =
            [Vector[1,0,0], Vector[0,1,0], Vector[0,0,1]].each(&:freeze).freeze

          @@cart_angular_momenta = {}
          def self.cart_angular_momenta l
            raise TypeError, "Expected #{Integer}, but %p" % [l] unless Integer === l
            @@cart_angular_momenta[l]||=
              CartAngularMomentumBasis.repeated_combination(l).map do |b|
                b.inject(Vector[0,0,0],&:+)
              end.each(&:freeze).freeze
          end

          def initialize azimuthal_quantum_numbers, coeffs, zetas
            @azimuthal_quantum_numbers = [azimuthal_quantum_numbers].flatten
            invalid_l = @azimuthal_quantum_numbers.find do |l|
              not l>=0 && Integer === l
            end
            raise ArgumentError, 'Invalid azimuthal quantum number!(%p)' % invalid_l if invalid_l
            raise ArgumentError, 'Number of azimuthal quantum numbers(%d) and coefficient sets(%d) don\'t match!' %
              [coeffs.count, @azimuthal_quantum_numbers.count] unless coeffs.count == @azimuthal_quantum_numbers.count
            coeffcounts = coeffs.map(&:count)
            raise ArgumentError, 'Sizes of coefficient sets(%s) is not unique!' % coeffcounts.join(',') unless
              coeffcounts.uniq.count == 1
            raise ArgumentError, 'Size of coefficient set(%d) and zeta set(%d) don\'t match!' %
              [coeffcounts.first, zetas.count] unless coeffcounts.first == zetas.count
            @sets_of_coeffs, @zetas = coeffs, zetas
          end

          def cart_angular_momenta_with_index
            @cart_angular_momenta_with_index ||=
            @azimuthal_quantum_numbers.each_with_index.flat_map do |l,i|
              momenta = self.class.cart_angular_momenta(l)
              [momenta, [i]*momenta.size].transpose
            end.freeze
          end

          def cart_angular_momenta
            cart_angular_momenta_with_index.transpose.first
          end

          def aos
            @aos ||=
            cart_angular_momenta_with_index.map do |momenta, i|
              RuPHY::AO::Gaussian::Contracted.new(@sets_of_coeffs[i], @zetas, momenta, self.center)
            end
          end

          def center
            raise NotImplementedError, "No center is defined!"
          end

          def contrdepth
            return @zetas.size
          end
        end
      end
    end
  end
end
