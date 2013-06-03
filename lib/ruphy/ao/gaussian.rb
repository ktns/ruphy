module RuPHY
  class AO
    class Gaussian < AO
      def initialize *args
        raise NotImplementedError
      end

      class Primitive < AO
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
              return 0.0
            elsif [t,i,j] == [0,0,0]
              return 1.0
            elsif i > 0
              return    E(t-1, i-1, j, xyz)/2/p +
              pa[xyz] * E(t,   i-1, j, xyz)     +
                (t+1) * E(t+1, i-1, j, xyz)
            else
              return    E(t-1, i, j-1, xyz)/2/p +
              pb[xyz] * E(t,   i, j-1, xyz)+
                (t+1) * E(t+1, i, j-1, xyz)
            end
          end
          alias E hermitian_coeffs

          # i in K_{AB} * x_A^i x_B^j exp(-p*x_P)
          def i xyz
            @primitive1.momenta[xyz]
          end

          # j in K_{AB} * x_A^i x_B^j exp(-p*x_P)
          def j xyz
            @primitive2.momenta[xyz]
          end

          def gauss3
            (PI/p)**1.5
          end

          # S_{ij} in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def overlap_decomposed xyz
            hermitian_coeffs(0,i(xyz),j(xyz),xyz)
          end

          # S_{ab} in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def overlap_integral
            [0,1,2].inject(1) do |sab,i|
              sab * overlap_decomposed(i)
            end * gauss3 * prefactor
          end

          # T_{ij} in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def kinetic_decomposed xyz
                             -2*b**2 * E(0, i(xyz), j(xyz)+2, xyz) \
                    + b*(2*j(xyz)+1) * E(0, i(xyz), j(xyz),   xyz) \
            -0.5 * j(xyz)*(j(xyz)-1) * E(0, i(xyz), j(xyz)-2, xyz)
          end

          # T_{ab} in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def kinetic_integral
            [0, 1, 2].inject(0.0) do |tab, i|
              ([0, 1, 2]-[i]).inject(kinetic_decomposed(i)) do |tij, j|
                tij * overlap_decomposed(j)
              end + tab
            end * gauss3 * prefactor
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
          (self*o).kinetic_integral
        end

        def kinetic o
          kinetic_raw(o) * normalization_factor * o.normalization_factor
        end

        def nuclear_attraction_raw other, atom
          (self*other).nuclear_attraction_integral(atom)
        end

        def nuclear_attraction other, atom
          nuclear_attraction_raw(other, atom) * normalization_factor * other.normalization_factor
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

        def normalization_factor
          @normalization_factor ||= overlap_raw(self)**-0.5
        end

        def overlap other
          overlap_raw(other) * normalization_factor * other.normalization_factor
        end

        def overlap_raw other
          case other
          when Primitive
            @primitives.inject(0) do |s, (c, primitive)|
              other.overlap(primitive) * c + s
            end
          when Contracted
            @primitives.inject(0) do |s, (c, primitive)|
              other.overlap_raw(primitive) * c + s
            end
          else
            raise TypeError, "Expected #{Primitive} or #{Contracted}, but `%p'" % [other]
          end
        end

        def kinetic other
          kinetic_raw(other) * normalization_factor * other.normalization_factor
        end

        def kinetic_raw other
          case other
          when Primitive
            @primitives.inject(0) do |s, (c, primitive)|
              other.kinetic(primitive) * c + s
            end
          when Contracted
            @primitives.inject(0) do |s, (c, primitive)|
              other.kinetic_raw(primitive) * c + s
            end
          else
            raise TypeError, "Expected #{Primitive} or #{Contracted}, but `%p'" % [other]
          end
        end

        def nuclear_attraction other, atom
          nuclear_attraction_raw(other, atom) * normalization_factor * other.normalization_factor
        end

        def nuclear_attraction_raw other, atom
          case other
          when Primitive
            @primitives.inject(0) do |s, (c, primitive)|
              other.nuclear_attraction(primitive, atom) * c + s
            end
          when Contracted
            @primitives.inject(0) do |s, (c, primitive)|
              other.nuclear_attraction_raw(primitive, atom) * c + s
            end
          else
            raise TypeError, "Expected #{Primitive} or #{Contracted}, but `%p'" % [other]
          end
        end
      end

    end
  end
end
