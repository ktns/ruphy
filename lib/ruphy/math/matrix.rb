require 'nmatrix'
require 'matrix'
require 'delegate'

module RuPHY
  module Math
    class Matrix < SimpleDelegator
      def initialize matrix
        raise TypeError, "Expected #{NMatrix}, but `%p'" % [matrix] unless NMatrix === matrix
        __setobj__ matrix.extend RespondToWorkaround
      end

      module RespondToWorkaround
        def respond_to? method, include_private = false
          super method or include_private &&
            private_methods.include?(method.intern)
        end
      end

      def diagonal_elements
        return enum_for(:diagonal_elements) unless block_given?
        __getobj__.shape.min.times do |i|
          yield __getobj__[i,i]
        end
      end

      def inner_product other
        column_size == other.column_size &&
          row_size == other.row_size or
          raise ExceptionForMatrix::ErrDimensionMismatch
        other = other.each(:all)
        self.each(:all).inject(0) do |p, e|
          p + e*other.next.conjugate
        end
      end

      def abs
        ::Math::sqrt(inner_product(self))
      end

      def inspect
        __getobj__.inspect.sub('NMatrix',self.class.to_s)
      end

      def square?
        n,m = shape
        n == m
      end

      def coerce other
        case other 
        when Numeric
          n, _ = shape
          [self.class.diagonal([other]*n), self]
        else
          raise TypeError, '%s cannot be coerced into %s' % [other.class, self.class]
        end
      end

      module MatrixWrapper
        def method_missing method, *args, &block
          args.map! do |arg|
            case arg
            when Matrix, Coercer
              arg.__getobj__
            else
              arg
            end
          end
          retval = super method, *args, &block
          loop do
            case retval
            when NMatrix
              Matrix.class_eval do
                return new(retval)
              end
            when ::Matrix
              Matrix.class_eval do
                return new(NMatrix[*retval])
              end
            when Coercer
              retval = retval.__getobj__
            else
              return retval
            end
          end
        end

        def inspect
          "#<#{self.class}: #{__getobj__.inspect}>"
        end
      end
      include MatrixWrapper

      class Coercer < SimpleDelegator
        def initialize obj
          __setobj__ obj
        end

        include MatrixWrapper
      end

      class << self
        private :new

        def method_missing method, *args, &block
          if NMatrix.respond_to? method
            new(NMatrix.send(method,*args, &block))
          elsif ::Matrix.respond_to? method
            new(NMatrix[*::Matrix.send(method, *args, &block).to_a])
          else
            super
          end
        end
      end
    end
  end

  Matrix = Math::Matrix
end
