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

        class PrimitiveProduct
          include RuPHY::Math
          def initialize g1, g2
            @primitive1, @primitive2 = g1,g2
          end

          # a in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def a
            @primitive1.zeta
          end

          # b in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def b
            @primitive2.zeta
          end

          # p in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def total_exponent
            a + b
          end
          alias p total_exponent

          # mu in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def reduced_exponent
            a*b/p
          end
          alias mu reduced_exponent

          # X_{ab} in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def separation
            @primitive1.center - @primitive2.center
          end
          alias x separation

          # K_{AB} in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def prefactor
            exp(-mu*x.r2)
          end
          alias k prefactor

          # P in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def center
            (a * @primitive1.center + b * @primitive2.center)/p
          end

          # PA in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def pa
            center - @primitive1.center
          end

          # PB in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def pb
            center - @primitive2.center
          end

          # E_t^{ij} in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def hermitian_coeffs t, i, j, xyz
            if t > i + j or t < 0
              0
            elsif [t,i,j] == [0,0,0]
              1
            elsif i > 0
                        E(t-1, i-1, j, xyz)/2/p +
              pa[xyz] * E(t,   i-1, j, xyz)     +
                (t+1) * E(t+1, i-1, j, xyz)
            else
                        E(t-1, i, j-1, xyz)/2/p +
              pb[xyz] * E(t,   i, j-1, xyz)+
                (t+1) * E(t+1, i, j-1, xyz)
            end
          end
          alias E hermitian_coeffs

          def overlap_integral
            [0,1,2].inject(1) do |e,i|
              e * hermitian_coeffs(0,@primitive1.momenta[i],@primitive2.momenta[i],i)
            end * (PI/p)**1.5
          end
        end

        def normalization_factor
          @normalization_factor ||= overlap_raw(self)**(-0.5)
        end

        @@products = {}

        def * other
          @@products[[self,other]] ||= PrimitiveProduct.new(self,other)
        end

        def overlap o
          overlap_raw(o) * normalization_factor * o.normalization_factor
        end

        def overlap_raw o
          (self*o).overlap_integral
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
