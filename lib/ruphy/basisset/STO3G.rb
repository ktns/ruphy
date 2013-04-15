require 'yaml'
require 'ruphy/ao/gaussian.rb'
require 'ruphy/basisset/lcao/gaussian'

module RuPHY
  module BasisSet
    module LCAO
      STO3G = YAML.load_file(File.join(File.dirname(__FILE__), 'STO-3G.yml'))

      class << STO3G
        attr_accessor :name
      end

      STO3G.name = 'STO-3G'

      STO3G.freeze
    end

    STO3G = LCAO::STO3G
  end
end
