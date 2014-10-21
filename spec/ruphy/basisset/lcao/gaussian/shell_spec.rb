require 'spec_helper'
require 'ruphy/basisset/lcao/gaussian/shell'

describe RuPHY::BasisSet::LCAO::Gaussian::Shell do
  describe '::CartAngularMomentumBasis' do
    subject{described_class::CartAngularMomentumBasis}

    it{is_expected.to be_frozen}

    it{is_expected.to be_all(&:frozen?)}

    its(:size){is_expected.to eq 3}
  end

  describe '.cart_angular_momenta' do
    shared_examples_for("proper cart_angular_momenta") do
      it{is_expected.to be_frozen}

      it{is_expected.to be_instance_of Array}
    end

    subject{described_class.cart_angular_momenta(l)}
    context 'l=0' do
      let(:l){0}

      it{is_expected.to eq [Vector[0,0,0]]}

      it_behaves_like("proper cart_angular_momenta")
    end

    context 'l=1' do
      let(:l){1}

      its(:size){is_expected.to eq 3}

      it{is_expected.to include Vector[1,0,0]}
      it{is_expected.to include Vector[0,1,0]}
      it{is_expected.to include Vector[0,0,1]}

      it_behaves_like("proper cart_angular_momenta")
    end

    context 'l=2' do
      let(:l){2}

      its(:size){is_expected.to eq 6}

      it{is_expected.to include Vector[2,0,0]}
      it{is_expected.to include Vector[0,2,0]}
      it{is_expected.to include Vector[0,1,1]}
      it{is_expected.to include Vector[1,0,1]}
      it{is_expected.to include Vector[1,1,0]}

      it_behaves_like("proper cart_angular_momenta")
    end
  end

  subject{shell}
  let(:shell){described_class.new(azimuthal_quantum_numbers, coeffs, zetas)}
  let(:azimuthal_quantum_numbers){0}
  let(:coeffs){[[1]]}
  let(:zetas){[1]}

  context 'with wrong azimuthal_quantum_numbers' do
    let(:azimuthal_quantum_numbers){-1}

    creating_it{is_expected.to raise_error ArgumentError,
                /^Invalid azimuthal quantum number!\(.*\)$/}
  end

  context 'with unmatching azimuthal quantum numbers and coefficient sets' do
    let(:azimuthal_quantum_numbers){[0,1]}

    creating_it{is_expected.to raise_error ArgumentError,
                /^Number of azimuthal quantum numbers\(\d+\) and coefficient sets\(\d+\) don\'t match!$/}
  end

  context 'with coefficients set of different sizes' do
    let(:azimuthal_quantum_numbers){[0,1]}
    let(:coeffs){[[1,1],[1]]}
    creating_it{is_expected.to raise_error ArgumentError,
                /^Sizes of coefficient sets\([\d,]+\) is not unique!$/}
  end

  context 'with unmatching coefficients and zetas' do
    let(:coeffs){[[0.5,0.5]]}
    let(:zetas){[1,2,3]}

    creating_it{is_expected.to raise_error ArgumentError,
                /^Size of coefficient set\(\d+\) and zeta set\(\d+\) don't match!$/}
  end

  context 'of S shell' do
    creating_it{is_expected.not_to raise_error}
  end

  describe '#aos' do
    let(:shell_with_center){shell.clone.extend TestCenter}

    context 'of S shell' do
      context 'without center' do
        subject{shell.aos()}

        calling_it{is_expected.to raise_error NotImplementedError}
      end

      context 'with center' do
        subject{shell_with_center.aos()}

        its(:size){is_expected.to eq 1}
      end
    end

    context 'of SP shell' do
      let(:azimuthal_quantum_numbers){[0,1]}
      let(:coeffs){[[1],[1]]}
      let(:zetas){[1]}

      context 'with center' do
        subject{shell_with_center.aos}

        its(:size){is_expected.to eq 4}
      end
    end
  end
end
