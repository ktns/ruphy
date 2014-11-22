module RuPHY
  module AO
    module Gaussian
      class Primitive
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

          # PC in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def PC atom
            center - atom.vector
          end

          # E_t^{ij} in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def hermitian_coeff_decomposed t, i, j, xyz
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
              pb[xyz] * E(t,   i, j-1, xyz)     +
                (t+1) * E(t+1, i, j-1, xyz)
            end
          end
          alias E hermitian_coeff_decomposed

          # E_{tuv}^{ab} in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def hermitian_coeff t, u, v
              E(t,i(0),j(0),0) *
              E(u,i(1),j(1),1) *
              E(v,i(2),j(2),2)
          end
          alias Eab hermitian_coeff

          # i in K_{AB} * x_A^i x_B^j exp(-p*x_P)
          def i xyz
            @primitive1.momenta[xyz]
          end

          # j in K_{AB} * x_A^i x_B^j exp(-p*x_P)
          def j xyz
            @primitive2.momenta[xyz]
          end

          def each_tuv &block
            unless block
              return to_enum(:each_tuv)
            end
            for t in 0..(i(0)+j(0))
              for u in 0..(i(1)+j(1))
                for v in 0..(i(2)+j(2))
                  yield t,u,v
                end
              end
            end
          end

          def gauss3
            (PI/p)**1.5
          end

          # S_{ij}*\sqrt{p/PI}=E^0_{ij} in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def overlap_decomposed xyz
            hermitian_coeff_decomposed(0,i(xyz),j(xyz),xyz)
          end

          # S_{ab} in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def overlap_integral
            (0..2).inject(1) do |sab,i|
              sab * overlap_decomposed(i)
            end * gauss3 * prefactor
          end

          # T_{ij}*\sqrt(p/PI) in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def kinetic_decomposed xyz
                             -2*b**2 * E(0, i(xyz), j(xyz)+2, xyz) \
                    + b*(2*j(xyz)+1) * E(0, i(xyz), j(xyz),   xyz) \
            -0.5 * j(xyz)*(j(xyz)-1) * E(0, i(xyz), j(xyz)-2, xyz)
          end

          # T_{ab} in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def kinetic_integral
            (0..2).inject(0.0) do |tab, i|
              ([0, 1, 2]-[i]).inject(kinetic_decomposed(i)) do |tij, j|
                tij * overlap_decomposed(j)
              end + tab
            end * gauss3 * prefactor
          end

          # R_{tuv}^{n}(p, R) in http://folk.uio.no/helgaker/talks/SostrupIntegrals_10.pdf
          def auxiliary_hermite_integral t,u,v,n,p,r
            if t < 0 or u < 0 or v < 0
              return 0
            elsif [t,u,v] == [0,0,0]
              return (-2*p)**n * F(p*r.r2,n)
            elsif [u,v] == [0,0]
              return r[0] * R(t-1, u,   v,   n+1, p, r) +
                    (t-1) * R(t-2, u,   v,   n+1, p, r)
            elsif v == 0
              return r[1] * R(t,   u-1, v,   n+1, p, r) +
                    (u-1) * R(t,   u-2, v,   n+1, p, r)
            else
              return r[2] * R(t,   u,   v-1, n+1, p, r) +
                    (v-1) * R(t,   u,   v-2, n+1, p, r)
            end
          end
          alias R auxiliary_hermite_integral

          # <G_a | Z/r_C | G_b>
          def nuclear_attraction_integral atom
            each_tuv.inject(0.0) do |vab, (t,u,v)|
              vab + Eab(t, u, v)* R(t,u,v,0,p,PC(atom))
            end * prefactor * 2*PI / p * atom.get_atomic_num
          end
          alias V nuclear_attraction_integral

          #< G_a(r_1) G_b(r_1) | r_{12}^{-1} | G_c(r_2) G_d(r_2) >
          def electron_repulsion_integral other
            p  = self.p
            q  = other.p
            pq = center - other.center
            a  = p*q/(p+q)
            prefactor = 2*PI**2.5/p/q/sqrt(p+q) * self.prefactor * other.prefactor
            each_tuv.inject(0.0) do |gabcd, (t1,u1,v1)|
              Eab(t1,u1,v1) *
              other.each_tuv.inject(gabcd) do |gcd, (t2,u2,v2)|
                gcd +
                other.Eab(t2,u2,v2) *
                   (-1)**(t2+u2+v2) *
                R(t1+t2,u1+u2,v1+v2,0, a, pq)
              end
            end * prefactor
          end
        end
      end

      class Contracted
        class Product
          def initialize g1, g2
            @g1, @g2 = g1, g2
            n = g1.normalization_factor*g2.normalization_factor
            @primitive_products = g1.each_primitives.flat_map do |c1, p1|
              g2.each_primitives.map do |c2, p2|
                next n * c1 * c2 * p1.normalization_factor * p2.normalization_factor, p1 * p2
              end
            end
          end

          def sum_up method, *args
            @primitive_products.inject(0) do |sum, (c, p)|
              sum + c * p.send(method, *args)
            end
          end
          protected :sum_up

          def overlap
            sum_up :overlap_integral
          end

          def kinetic
            sum_up :kinetic_integral
          end

          def nuclear_attraction atom
            sum_up :nuclear_attraction_integral, atom
          end

          def electron_repulsion other
            @primitive_products.inject(0) do |sum, (c, p)|
              sum + c * other.sum_up(:electron_repulsion_integral, p)
            end
          end
        end
      end
    end
  end
end
