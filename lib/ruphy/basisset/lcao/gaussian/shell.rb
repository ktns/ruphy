require 'ruphy/ao/gaussian/shell'

module RuPHY
  module BasisSet
    module LCAO
      class Gaussian
        include BasisSet
        class Shell
          include RuPHY::AO::Gaussian::Shell
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

          attr_reader :azimuthal_quantum_numbers, :sets_of_coeffs, :zetas
        end
      end
    end
  end
end
