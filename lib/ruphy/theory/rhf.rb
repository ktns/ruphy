require 'ruphy/mo/basis'

module RuPHY
  module Theory
    module RHF
      class MO
        include RuPHY::MO

        def setup_number_of_electrons geometry, opts = {}
          @n = opts.fetch(:number_of_electrons) do
            geometry.total_nuclear_charge - opts.fetch(:total_charge, 0)
          end
          raise TypeError, "Expected #{Integer}, got #{number_of_electrons.class}" unless @n.is_a? Integer
          raise ArgumentError, "Expected positive integer, got #{@n}" unless @n > 0
        end

        def initialize geometry, basis, opts = {}
          setup_number_of_electrons geometry, opts
          @geometry = geometry
          case basis
          when MO::Basis
            @basis = basis
          else
            @basis = basis.span(:geometry => geometry, :number_of_electrons => @n)
          end
          @basis.freeze
          @vectors = nil
          @energies = nil
        end

        attr_reader :n, :geometry, :basis, :vectors, :energies
        alias number_of_electrons n
      end

      class Solver
        def initialize geometry, basisset
          raise NotImplementedError
        end
      end
    end
  end
end
