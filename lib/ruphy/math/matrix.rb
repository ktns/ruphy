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
        each :diagonal, &block
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
