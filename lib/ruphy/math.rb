module RuPHY
  module Math
    include ::Math

    def boys(r,m)
      raise ArgumentError, 'r=%e < 0!' % r if r < 0
      if r == 0
        return 1.0/(2*m+1)
      end
      case m
      when 0
        rr = sqrt(r)
        return sqrt(PI) * erf(rr) / 2 / rr
      when -Float::INFINITY...0
        raise ArgumentError, 'Negative m specified!'
      when Integer
        if r < 1e-2
          return (0..10).inject(0) do |f,i|
            f + 1.0/(2*(i+m)+1) * (-r)**i
          end
        else
          return (boys(r,m-1) * (2*m-1) - exp(-r)) / 2 / r
        end
      else
        raise ArgumentError, 'Unsupported value for m(=%p)!' % m
      end
    end
    private
    alias F boys
    public

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

    def double_factorial n
      n.step(1, -2).reduce(1,&:*)
    end

    class <<self
      include RuPHY::Math
    end

    def included mod
      mod.module_eval do
        private *RuPHY::Math.instance_methods(false)
      end
    end

    # Solve $Ax = \lambda Bx$
    # Returns Array of eigenvalues and Matrix of eigenvectors
    def solve_generalized_symmetric_eigenproblem a, b
      if a.hermitian? and b.hermitian?
      _, energies_matrix, vectors = *(b**-0.5*a*b**-0.5).eigensystem
      energies = energies_matrix.each(:diagonal).to_a
      vectors = Matrix[*(0...vectors.column_size).sort_by do |i|
        energies[i]
      end.map do |i|
        vectors.row(i)
      end]
      vectors*=b**-0.5
      return [energies.sort, vectors]
      else
        raise NotImplementedError, 'Solver for GSEP with non-hermitian matrix is not implemented'
      end
    end

    alias solve_GSEP solve_generalized_symmetric_eigenproblem
  end
end

require 'ruphy/math/matrix'
require 'ruphy/math/vector'
