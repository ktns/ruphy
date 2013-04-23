require 'matrix'
require 'delegate'

module RuPHY
  module Math
    class Matrix < SimpleDelegator
      def initialize matrix
        raise TypeError, "Expected #{::Matrix}, but `%p'" % [matrix] unless ::Matrix === matrix
        __setobj__ matrix
      end

      def diagonal_elements &block
        begin
          each :diagonal, &block
        rescue ArgumentError
          if block then
            [row_size,column_size].min.times{|i| yield self[i,i]}
          else
            enumerator = Enumerator
            enumerator.new(self,:diagonal_elements)
          end
        end
      end

      def coerce other
        [ other, __getobj__ ]
      end

      class << self
        private :new

        def method_missing method, *args, &block
          new(::Matrix.send(method,*args, &block))
        end
      end
    end
  end

  Matrix = Math::Matrix
end
