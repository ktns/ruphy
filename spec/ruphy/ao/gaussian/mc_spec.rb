require 'spec_helper'
require 'ruphy/ao/gaussian/mc'

describe RuPHY::AO::Gaussian::Primitive::PrimitiveProduct::MC do
  let(:product){ pending }

  let(:product_mc) do
    product.dup.extend described_class
  end

  shared_examples CwDEM = "consistent with default evaluation method" do |integral, *args|
    subject{product_mc.send(integral,*args)}
    let(:default_eval){product.send(integral,*args)}

    it 'should be consistent with default evaluation method' do
      should be_within(1e-5).of default_eval
    end
  end

  describe '#overlap_integral' do
    include_examples CwDEM, :overlap_integral
  end

  describe '#kinetic_integral' do
    include_examples CwDEM, :kinetic_integral
  end

  describe '#nuclear_attraction_integral' do
    let(:atom) do
      double(:atom).tap do

      end
    end

    include_examples CwDEM, :nuclear_attraction_integral, proc{atom}
  end

  describe '#electron_repulsion_integral' do
    let(:other_product){pending}

    include_examples CwDEM, :electron_repulsion_integral, proc{other_product}
  end
end
