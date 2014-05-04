require 'ruphy/ao/gaussian'

# This module contains methods that
# evaluate molecular integrals using Monte Carlo method.
module RuPHY::AO::Gaussian::Primitive::PrimitiveProduct::MC
  Primitive = RuPHY::AO::Gaussian::Primitive
  include Math

  private
  def rand *args
    random_generator.rand *args
  end

  def random_generator
    @random_generator ||= Random.new
  end

  #returns two independent random numbers
  #obeying the standard Gaussian distribution
  #using Box-Muller's method
  def gaussian_rand2
    x = rand(0.0..1.0)
    theta = rand(0.0..2*PI)
    r = sqrt(-2*log(x))
    return r*cos(theta), r*sin(theta)
  end

  # iterate with random points
  def iterate_points
    return to_enum(:iterate_points) unless block_given?
    loop do
      x,y,z,w = *gaussian_rand2, *gaussian_rand2
      yield x,y,z
      x,y,z = w, *gaussian_rand2
      yield x,y,z
    end
  end

  def volume_factor
    p ** -1.5 * PI ** 1.5 * prefactor
  end

  def integrate tolerant_error=1e-3
    tolerant_error/=volume_factor
    tolerant_variance=tolerant_error**2
    iterate_points.each_with_index.inject([0,0]) do |*args|
      (fsum, fsqsum), ((x,y,z),n) = *args
      rp = Vector[x,y,z]/3/p
      ra = rp + pa
      rb = rp + pb
      f = yield ra, rb
      fsum+=f
      fsqsum+=f**2
      next fsum, fsqsum if n < N
      n+=1
      fmean = fsum/n
      var = (fsqsum/n-fmean**2)/n
      break fmean if var < tolerant_variance
      next fsum, fsqsum
    end * volume_factor
  end

  # Minimum number of samples
  N = 1000
  public
  def overlap_integral tolerant_error=1e-3
    integrate tolerant_error do |ra, rb|
      [ra.to_a, @primitive1.momenta].transpose.concat(
        [rb.to_a, @primitive2.momenta].transpose
      ).inject(1) do |azim, (x, i)|
        azim * x**i
      end
    end
  end

  def kinetic_integral tolerant_error=1e-3
    integrate tolerant_error do |ra, rb|
      [ra.to_a, @primitive1.momenta].transpose.concat(
        [rb.to_a, @primitive2.momenta].transpose
      ).inject(1) do |azim, (x, i)|
        azim * x**i
      end *
      [rb.to_a, @primitive2.momenta].transpose.inject(0) do |kinetic_coeff, (x,i)|
        x**-2*(i**2-i - 2*a*x**2*(2*i-1) + 4*a**2*x**i) + kinetic_coeff
      end
    end
  end

  def nuclear_attraction_integral atom
    raise NotImplementedError
  end

  def electron_repulsion_integral other
    raise NotImplementedError
  end
end
