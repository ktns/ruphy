require 'ruphy/ao/gaussian'
require 'ruphy/basisset/lcao/gaussian/shell'

module RuPHY
  module BasisSet
    module LCAO
      class Gaussian < BasisSet::Base
        class InvalidElementError < ArgumentError
          def initialize e
            super 'Invalid Element `%p\'!' % e
          end
        end

        class ElementNotFoundError < ArgumentError
          def initialize e
            super 'Element `%s\' is not in this basis set!' % e
          end
        end

        class Hash < ::Hash
          def initialize
            super do |e|
              if RuPHY::Element === e or RuPHY::Elements[e]
                raise ElementNotFoundError.new(e)
              else
                raise InvalidElementError.new(e)
              end
            end
          end

          def []= e,b
            begin
              unless e = RuPHY::Elements[e]
                raise InvalidElementError.new(e)
              end
            rescue
              raise InvalidElementError.new(e)
            end
            super
          end
        end

        def initialize arg
          @comment = arg.delete(:comment)
          @basisset = Hash.new.tap do |s|
            arg.each do |(e,b)|
              s[e] = b
            end
          end.freeze
        end
        attr_reader :comment

        def elements
          @basisset.keys
        end
      end
    end
  end
end
