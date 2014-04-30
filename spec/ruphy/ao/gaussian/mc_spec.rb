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
      should be_within(5e-3).of default_eval
    end
  end

  describe '#overlap_integral' do
    let(:s1){ described_class::Primitive.new(rand(0.0..4.0), [0,0,0], center1) }
    let(:s2){ described_class::Primitive.new(rand(0.0..4.0), [0,0,0], center2) }
    let(:pz1){ described_class::Primitive.new(rand(0.0..4.0), [0,0,1], center1) }
    let(:pz2){ described_class::Primitive.new(rand(0.0..4.0), [0,0,1], center2) }
    let(:center1){ [0,0,0] }
    let(:center2){ 3.times.map{rand(0.1..3.0)} }

    context 'of type <s|s>' do

      context 'on one center' do
        #let(:product) { s1 * s1 }

        include_examples CwDEM, :overlap_integral
      end

      context 'on two centers' do
        #let(:product) { s1 * s2 }

        include_examples CwDEM, :overlap_integral
      end
    end

    context 'of type <s|p>' do
      context 'on one center' do
        #let(:product) { s1 * pz1 }

        include_examples CwDEM, :overlap_integral
      end

      context 'on two centers' do
        #let(:product) { s1 * pz2 }

        include_examples CwDEM, :overlap_integral
      end
    end
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
