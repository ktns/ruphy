require 'ruphy/ao/gaussian'

# This module contains methods that
# evaluate molecular integrals using Monte Carlo method.
module RuPHY::AO::Gaussian::Primitive::PrimitiveProduct::MC
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

  public
  def overlap_integral
    raise NotImplementedError
  end

  def kinetic_integral
    raise NotImplementedError
  end

  def nuclear_attraction_integral atom
    raise NotImplementedError
  end

  def electron_repulsion_integral other
    raise NotImplementedError
  end
end
