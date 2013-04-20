module RuPHY
  module BasisSet
    module LCAO
      class Gaussian < BasisSet::Base
        class Shell
          CartAngularMomentumBasis =
            [Vector[1,0,0], Vector[0,1,0], Vector[0,0,1]].each(&:freeze).freeze

          @@cart_angular_momenta = {}
          def self.cart_angular_momenta l
            @@cart_angular_momenta[l]||=
              CartAngularMomentumBasis.repeated_combination(l).map do |b|
                b.inject(Vector[0,0,0],&:+)
              end.each(&:freeze).freeze
          end

          def initialize azimuthal_quantum_numbers, coeffs, zetas
            @azimuthal_quantum_numbers = [azimuthal_quantum_numbers].flatten
            l = @azimuthal_quantum_numbers.find do |l|
              not l>=0 && Integer === l
            end
            raise ArgumentError, 'Invalid azimuthal quantum number!(%p)' % l if l
            raise ArgumentError, 'Number of azimuthal quantum numbers(%d) and coefficient sets(%d) don\'t match!' %
              [coeffs.count, @azimuthal_quantum_numbers.count] unless coeffs.count == @azimuthal_quantum_numbers.count
            coeffcounts = coeffs.map(&:count)
            raise ArgumentError, 'Sizes of coefficient sets(%s) is not unique!' % coeffcounts.join(',') unless
              coeffcounts.uniq.count == 1
            raise ArgumentError, 'Size of coefficient set(%d) and zeta set(%d) don\'t match!' %
              [coeffcounts.first, zetas.count] unless coeffcounts.first == zetas.count
            @coeffs, @zetas = coeffs, zetas
          end

          def cart_angular_momenta
            @azimuthal_quantum_numbers.map do |l|
              self.class.cart_angular_momenta(l)
            end.flatten(1)
          end

          def aos
            cart_angular_momenta.map do |momenta|
              RuPHY::AO::Gaussian::Contracted.new(@coeffs, @zetas, momenta, self.center)
            end
          end

          def center
            raise NotImplementedError, "No center is defined!"
          end
        end
      end
    end
  end
end
