require 'matrix'
require 'delegate'

module RuPHY
  module Math
    class Matrix < SimpleDelegator
      def initialize matrix
        @delegate_sd_obj = matrix
      end

      def diagonal_elements &block
        begin
          each :diagonal, &block
        rescue ArgumentError
          if block then
            [row_size,column_size].min.times{|i| yield self[i,i]}
          else
            enumerator = Enumerator rescue enumerator = Enumerable::Enumerator
            enumerator.new(self,:diagonal_elements)
          end
        end
      end

      def coerce other
        [ other, @delegate_sd_obj ]
      end

      class << self
        private :new

        def method_missing method, *args
          new(::Matrix.send(method,*args))
        end
      end
    end
  end

  Matrix = Math::Matrix
end
