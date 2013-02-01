require 'spec_helper'
require 'ruphy/basisset/lcao/gaussian/shell'

describe RuPHY::BasisSet::LCAO::Gaussian::Shell do
  describe '::CartAngularMomentumBasis' do
    subject{described_class::CartAngularMomentumBasis}

    it{should be_frozen}

    it{should be_all(&:frozen?)}

    its(:size){should eq 3}
  end

  describe '.cart_angular_momenta' do
    subject{described_class.cart_angular_momenta(l)}
    context 'l=0' do
      let(:l){0}

      it{should eq [Vector[0,0,0]]}

      it{should be_frozen}
    end

    context 'l=1' do
      let(:l){1}

      its(:size){should eq 3}

      it{should include Vector[1,0,0]}
      it{should include Vector[0,1,0]}
      it{should include Vector[0,0,1]}

      it{should be_frozen}
    end

    context 'l=2' do
      let(:l){2}

      its(:size){should eq 6}

      it{should include Vector[2,0,0]}
      it{should include Vector[0,2,0]}
      it{should include Vector[0,1,1]}
      it{should include Vector[1,0,1]}
      it{should include Vector[1,1,0]}

      it{should be_frozen}
    end
  end

  subject{shell}
  let(:shell){described_class.new(azimuthal_quantum_numbers, coeffs, zetas, center)}
  let(:coeffs){[1]}
  let(:zetas){[1]}
  let(:center){[0,0,0]}

  context 'with wrong azimuthal_quantum_numbers' do
    let(:azimuthal_quantum_numbers){-1}

    creating_it{should raise_error ArgumentError}
  end

  context 'with unmatching coefficients and zetas' do
    let(:azimuthal_quantum_numbers){0}
    let(:coeffs){[0.5,0.5]}
    let(:zetas){[1]}

    creating_it{should raise_error ArgumentError}
  end

  context 'of S shell' do
    let(:azimuthal_quantum_numbers){0}

    creating_it{should_not raise_error}
  end

  describe '#aos' do
    context 'of S shell' do
      let(:azimuthal_quantum_numbers){0}

      subject{shell.aos()}

      its(:size){should == 1}
    end
  end
end
