require 'ruphy/math'
require_relative 'gaussian/product'

module RuPHY
  module AO
    module Gaussian
      include AO

      class Primitive
        include Gaussian
        public_class_method :new

        def initialize zeta, momenta, center
          @zeta, @momenta, @center = [zeta.to_f,
            (momenta.to_ary rescue momenta.to_a),
            (center.vector rescue Vector[*center])].map(&:freeze)
          raise ArgumentError, 'Invalid value for a zeta(%p)!' % zeta unless @zeta > 0
          raise ArgumentError, 'Invalid size of momenta(%d)!' % @momenta.size unless @momenta.size == 3
          @momenta.each do |m|
            raise TypeError, 'Invalid type for a momentum(%p)!' % m.class unless m.kind_of?(Integer)
            raise ArgumentError, 'Invalid value for a momentum(%d)!' % m unless m>=0
          end
          raise ArgumentError, 'Invalid dimension of center coordinates(%d)!' % @center.size unless @center.size == 3
        end

        attr_reader :zeta, :momenta, :center

        def angular_momentum
          @momenta.reduce(:+)
        end

        def normalization_factor
          @normalization_factor ||= overlap_raw(self)**(-0.5)
        end

        @@products = {}

        def * other
          case other
          when Primitive
            return @@products[[self,other]] ||= PrimitiveProduct.new(self,other)
          else
            begin
            a,b = other.coerce(self)
            rescue NoMethodError, RuntimeError
              raise TypeError, "#{other.class} cannot be coerced into #{self.class}"
            end
            return a*b
          end
        end

        # Normalized overlap integral
        def overlap o
          overlap_raw(o) * normalization_factor * o.normalization_factor
        end

        # Unnormalized overlap integral
        def overlap_raw o
          (self*o).overlap_integral
        end

        # Unnormalized kinetic integral
        def kinetic_raw o
          (self*o).kinetic_integral
        end

        # Normalized kinetic integral
        def kinetic o
          kinetic_raw(o) * normalization_factor * o.normalization_factor
        end

        # Unnormalized nuclear attraction integral
        def nuclear_attraction_raw other, atom
          (self*other).nuclear_attraction_integral(atom)
        end

        # Normalized nuclear attraction integral
        def nuclear_attraction other, atom
          nuclear_attraction_raw(other, atom) * normalization_factor * other.normalization_factor
        end

        # Enumerate self with pseudo coefficient 1
        def each_primitives &block
          [[1, self]].each &block
        end
      end

      class Contracted
        include Gaussian
        def initialize coeffs, zetas, momenta, center
          begin
            @primitives=[coeffs,zetas].transpose.map do |c,zeta|
              [c, Primitive.new(zeta,momenta,center)]
            end
          rescue Exception
            if exception = zetas.find{|z| z.to_f && false rescue true}
              #raise ArgumentError, "`%p' out of zetas cannot be converted to Float!" % exception <= wrong
              raise ArgumentError, "`%p' out of zetas cannot be converted to Float!" % [exception]
            else
              raise $!
            end
          end
        end

        def momenta
          @primitives.first.last.momenta
        end

        def angular_momentum
          @primitives.first.last.angular_momentum
        end

        # Enumerate primitives and coefficients
        def each_primitives &block
          @primitives.each &block
        end

        @@products = {}

        def * other
          @@products[[self,other]] ||= Product.new(self, other)
        end

        def coerce other
          case other
          when Primitive
            [PrimitiveDummy.new(other), self]
          else
            raise TypeError "#{other.class} cannot coerced into #{self.class}"
          end
        end

        class PrimitiveDummy < Contracted
          def initialize primitive
            @primitives = [[1, primitive]]
          end
        end

        def normalization_factor
          @normalization_factor ||= @primitives.inject(0) do |n, (c1, p1)|
            @primitives.inject(n) do |n, (c2, p2)|
            n + c1 * c2 * p1.overlap(p2)
          end
          end ** -0.5
        end

        # Normalized overlap integral
        def overlap other
          (self*other).overlap
        end

        # Normalized kinetic integral
        def kinetic other
          (self*other).kinetic
        end

        # Normalized nuclear attraction integral
        def nuclear_attraction other, atom
          (self*other).nuclear_attraction(atom)
        end
      end
    end
  end
end
