require 'ruphy/ao/gaussian.rb'
require 'ruphy/basisset/lcao/gaussian'

module RuPHY
  module BasisSet
    module LCAO
      class Gaussian
        class STO3G < Base
          def initialize element, center
            @bases = []
            case element
            when 'H'
              @bases << AO::Gaussian::Contracted.new(
                [0.15432897,0.53532814,0.44463454],
                [3.42525091,0.62391373,0.16885540],
                [0,0,0],
                center)
            end
          end

          def each &block
            @bases.each &block
          end
        end
      end
    end

    STO3G = LCAO::Gaussian::STO3G
  end
end
