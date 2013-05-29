module RuPHY
  module Math
    include ::Math

    def boys(r,m)
      case m
      when 0
        rr = sqrt(r)
        return sqrt(PI) * erf(rr) / 2 / rr
      when Integer
        raise ArgumentError, 'Negative m specified!' unless m >= 0
        return (boys(r,m-1) * (2*m-1) - exp(-r)) / 2 / r
      else
        raise ArgumentError, 'Unsupported value for m(=%p)!', m
      end
    end

    # calculate one dimensional integral over entire space of
    # (x-a)^m(x-b)^n exp(-z*x^2)
    def cart_gauss_integral a,b,m,n,z
      e=m+n
      if e > 0
        d=e+1
        coefs=Vector[1,*[0]*e]
        shifter=::Matrix[*[[0]*d]+(::Matrix.identity(e).to_a+[[0]*e]).transpose]
        coefs=(m>0 ? (::Matrix.identity(d)*-a+shifter)**m : ::Matrix.identity(d))*coefs
        coefs=(n>0 ? (::Matrix.identity(d)*-b+shifter)**n : ::Matrix.identity(d))*coefs
        coefs.to_a.each_with_index.inject(0) do |s,(a,n)|
          if n % 2 == 0
            s + a*(n-1).downto(1).reduce(1,:*).downto(1).reduce(1,:*)/(2*z)**(n/2)
          else
            s
          end
        end
      else
        1
      end*sqrt(PI/z)
    end

    class <<self
      include RuPHY::Math
    end
  end
end

require 'ruphy/math/matrix'
require 'ruphy/math/vector'
