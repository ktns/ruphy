require 'ruphy/ao/gaussian'

# This module contains methods that
# evaluate molecular integrals using Monte Carlo method.
module RuPHY::AO::Gaussian::Primitive::PrimitiveProduct::MC
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
