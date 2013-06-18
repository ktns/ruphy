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

      def inner_product other
        column_size == other.column_size &&
          row_size == other.row_size or
          raise ExceptionForMatrix::ErrDimensionMismatch
        other = other.each(:all)
        self.each(:all).inject(0) do |p, e|
          p + e*other.next.conjugate
        end
      end

      def inspect
        __getobj__.inspect.sub('Matrix',self.class.to_s)
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
            when ::Matrix
              Matrix.class_eval do
                return new(retval)
              end
            when Coercer
              retval = retval.__getobj__
            else
              return retval
            end
          end
        end

        def coerce other
          other, self_ = super
          return [Coercer.new(other), self_]
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

      def coerce other
        other, self_ = super
        return [Coercer.new(other), self_]
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
