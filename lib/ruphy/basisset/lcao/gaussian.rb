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
              unless e.kind_of? RuPHY::Element or e = RuPHY::Elements[e]
                raise InvalidElementError.new(e)
              end
            rescue
              raise InvalidElementError.new(e)
            end
            super
          end
        end

        module YAML
          include ::YAML

          # Modify the emit style for comments of basissets
          module CommentStyle
            # Define emit style for Syck
            def to_yaml_style
              :literal
            end

            # TODO: Emit literal style string with psych
            #def encode_with coder
            #end

            # Allow only String to extend this module
            def self.extended obj
              unless obj.kind_of? String
                raise TypeError, "%s is extended by %s instead of %s" % [
                  self,
                  obj.class,
                  String
                ]
              end
            end
          end
        end

        def initialize arg
          @comment = arg.delete(:comment) and @comment.extend YAML::CommentStyle
          @name    = arg.delete(:name)
          @basisset = Hash.new.tap do |s|
            arg.each do |(e,b)|
              s[e] = b
            end
          end.freeze
        end
        attr_reader :comment
        attr_reader :name

        def elements
          @basisset.keys
        end

        def inspect
          "#<#{self.class}:#{@name} [#{elements.join(',')}]>"
        end

        def shells arg
          case arg
          when Geometry::Atom
            @basisset[arg.element]
          when Element
            @basisset[arg]
          else
            raise TypeError, "expected #{Geometry::Atom} or #{Element}, but #{arg.class}"
          end
        end
      end
    end
  end
end
