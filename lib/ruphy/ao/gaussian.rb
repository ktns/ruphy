module RuPHY
  class AO
    class Gaussian < AO
      def initialize *args
        raise NotImplementedError
      end

      class Primitive < AO
        include RuPHY::Math

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

        def overlap o
          overlap_raw(o) * normalization_factor * o.normalization_factor
        end

        def overlap_raw o
          z=@zeta+o.zeta
          c=(@center*@zeta+o.center*o.zeta)*z**-1.0
          [@center-c,o.center-c,@momenta,o.momenta].map(&:to_a).transpose.map do |a,b,m,n|
            cart_gauss_integral(a,b,m,n,z)
          end.reduce(:*) * exp(-@zeta*o.zeta/z*(@center-o.center).r**2)
        end

        def kinetic_raw o
          z = @zeta+o.zeta
          c = (@center*@zeta + o.center*o.zeta)*z**-1.0
          3.times.map do |i|
            [@center-c,o.center-c,@momenta,o.momenta].map(&:to_a).transpose.each_with_index.map do |(a,b,m,n),j|
              if i==j
                4*o.zeta**2*cart_gauss_integral(a,b,m,n+2,z) - 
                  2*o.zeta*(2*n+1)*cart_gauss_integral(a,b,m,n,z) +
                  (n>1 ? n*(n-1)*cart_gauss_integral(a,b,m,n-2,z) : 0)
              else
                cart_gauss_integral(a,b,m,n,z)
              end
            end.reduce(:*)
          end.reduce(:+) * exp(-@zeta*o.zeta/z*(@center-o.center).r**2)/-2
        end

        def kinetic o
          kinetic_raw(o) * normalization_factor * o.normalization_factor
        end
      end

      class Contracted < AO
        public_class_method :new

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
      end
    end
  end
end
