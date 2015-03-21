require 'nmatrix'
require 'matrix'
require 'delegate'

module RuPHY
  module Math
    class Matrix < SimpleDelegator
      def initialize matrix
        raise TypeError, "Expected #{NMatrix}, but `%p'" % [matrix] unless NMatrix === matrix
        __setobj__ matrix
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

      def each which = :all, &block
        case which
        when :all
          __getobj__.each &block
        when :diagonal
          return enum_for(:each, :diagonal) unless block_given?
          each_with_index do |e, (i, j)|
            yield e if i == j
          end
        when :off_diagonal
          return enum_for(:each, :off_diagonal) unless block_given?
          each_with_index do |e, (i, j)|
            yield e unless i == j
          end
        else
          raise ArgumentError, 'Expected `%p\' to be one of :all, :diagonal' % which
        end
      end

      def each_with_index &block
        if vector?
          super
        else
          prc = lambda do |nm, shape, indeces, prc, &block|
            n = shape.pop
            if shape.empty?
              n.times do |i|
                i = [*indeces, i]
                block.call(nm[*i], i)
              end
            else
              n.times do |i|
                i = [*indeces, i]
                prc.call(nm, shape.dup, i, prc, &block)
              end
            end
          end
          prc.call(__getobj__, __getobj__.shape, [], prc, &block)
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

      unless NMatrix.instance_methods.include?(:index)
        def index v
          each_with_indices do |e, i, j|
            return [i, j] if e == v
          end
          nil 
        end
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
