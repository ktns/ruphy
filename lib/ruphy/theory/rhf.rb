require 'ruphy/mo/basis'

module RuPHY
  module Theory
    module RHF
      class MO
        include RuPHY::MO
        def initialize geometry, basis, number_of_electrons
          raise NotImplementedError
        end
      end

      class Solver
        def initialize geometry, basisset
          raise NotImplementedError
        end
      end
    end
  end
end
