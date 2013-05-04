require 'spec_helper'

describe RuPHY::AO::Gaussian do

end

describe RuPHY::AO::Gaussian::Primitive do
  describe '.new' do
    it 'should accept zeta, momenta, and center' do
      lambda do
        described_class.new 1.0, [0,0,0], Vector[0,0,0]
      end.should_not raise_error
    end

    it 'should not accept wrong dimension of momenta' do
      lambda do
        described_class.new 1.0, [0,0,0,0], Vector[0,0,0]
      end.should raise_error ArgumentError
    end

    it 'should not accept wrong dimension of center coordinates' do
      lambda do
        described_class.new 1.0, [0,0,0], Vector[0,0,0,0]
      end.should raise_error ArgumentError
    end
  end

  shared_examples_for 'a primitive'	do
    let(:primitive ){ described_class.new(zeta,momenta,center)}

    subject{primitive}

    its(:zeta){ should be_frozen }

    its(:momenta){ should be_frozen }

    its(:center){ should be_frozen }

    describe '#normalization_factor' do
      subject{primitive.normalization_factor}

      it "should return correct value" do
        should be_within(1e-5).of(
          (2/Math::PI)**0.75*
          2**momenta.reduce(:+)*
          zeta**((2*momenta.reduce(:+)+3).to_f/4)/
          momenta.map do |m|
            m==0 ? 1 :
              (2*m-1).downto(1).reduce(:*).downto(1).reduce(:*)
          end.reduce(:*)**0.5
        )
      end
    end

    describe "its overlap with self" do
      subject{primitive.overlap(primitive)}

      it{should be_within(0.1).percent_of(1)}
    end

    its(:angular_momentum) do
      should == momenta.reduce(:+)
    end

    describe 'diagonal kinetic integal' do
      subject{primitive.kinetic(primitive)}

      it {should_not == 0}
    end

    its(:deriv_x) do
      subject.deriv_x.derivative_order.should == subject.derivative_order + Vector[1,0,0]
    end

    its(:deriv_y) do
      subject.deriv_y.derivative_order.should == subject.derivative_order + Vector[0,1,0]
    end

    its(:deriv_z) do
      subject.deriv_z.derivative_order.should == subject.derivative_order + Vector[0,0,1]
    end
  end

  describe 's primitive with zeta = 1.0' do
    let(:zeta){1.0}
    let(:momenta){[0,0,0]}
    let(:center){[0,0,0]}
    it_behaves_like 'a primitive'
  end

  describe 'px primitive with zeta = 1.0' do
    let(:zeta){1.0}
    let(:momenta){[1,0,0]}
    let(:center){[0,0,0]}
    it_behaves_like 'a primitive'
  end

  describe 'py primitive with zeta = 1.0' do
    let(:zeta){1.0}
    let(:momenta){[0,1,0]}
    let(:center){[0,0,0]}
    it_behaves_like 'a primitive'
  end

  describe 'pz primitive with zeta = 1.0' do
    let(:zeta){1.0}
    let(:momenta){[0,0,1]}
    let(:center){[0,0,0]}
    it_behaves_like 'a primitive'
  end

  describe 'dxy primitive with zeta = 1.0' do
    let(:zeta){1.0}
    let(:momenta){[1,1,0]}
    let(:center){[0,0,0]}
    it_behaves_like 'a primitive'
  end

  describe 'dyz primitive with zeta = 1.0' do
    let(:zeta){1.0}
    let(:momenta){[0,1,1]}
    let(:center){[0,0,0]}
    it_behaves_like 'a primitive'
  end

  describe 'dzx primitive with zeta = 1.0' do
    let(:zeta){1.0}
    let(:momenta){[1,0,1]}
    let(:center){[0,0,0]}
    it_behaves_like 'a primitive'
  end

  describe 'dx^2 primitive with zeta = 1.0' do
    let(:zeta){1.0}
    let(:momenta){[2,0,0]}
    let(:center){[0,0,0]}
    it_behaves_like 'a primitive'
  end

  describe 'dy^2 primitive with zeta = 1.0' do
    let(:zeta){1.0}
    let(:momenta){[0,2,0]}
    let(:center){[0,0,0]}
    it_behaves_like 'a primitive'
  end

  describe 'dz^2 primitive with zeta = 1.0' do
    let(:zeta){1.0}
    let(:momenta){[0,0,2]}
    let(:center){[0,0,0]}
    it_behaves_like 'a primitive'
  end

  describe 'primitive centerd on Atom' do
    let(:zeta){1.0}
    let(:momenta){[0,0,2]}
    let(:center){dummy_atom}
    it_behaves_like 'a primitive'
  end

  shared_examples_for 'mutually orthogonal p primitives with identical center' do
    let(:primitive1) {described_class.new(zeta1,momenta1,center)}
    let(:primitive2) {described_class.new(zeta2,momenta2,center)}

    it 'should have overlap of 0' do
      primitive1.overlap(primitive2).should be_within(1e-5).of(0)
    end
  end

  describe 'px and py primitives with zeta = 1.0' do
    let(:zeta1){1.0}
    let(:zeta2){1.0}
    let(:momenta1){[1,0,0]}
    let(:momenta2){[0,1,0]}
    let(:center){[0,0,0]}
    it_behaves_like 'mutually orthogonal p primitives with identical center'
  end

  describe 'py and pz primitives with zeta = 1.0' do
    let(:zeta1){1.0}
    let(:zeta2){1.0}
    let(:momenta1){[0,1,0]}
    let(:momenta2){[0,0,1]}
    let(:center){[0,0,0]}
    it_behaves_like 'mutually orthogonal p primitives with identical center'
  end

  describe 'pz and px primitives with zeta = 1.0' do
    let(:zeta1){1.0}
    let(:zeta2){1.0}
    let(:momenta1){[0,0,1]}
    let(:momenta2){[1,0,0]}
    let(:center){[0,0,0]}
    it_behaves_like 'mutually orthogonal p primitives with identical center'
  end

  shared_examples_for 'mutually orthogonal p primitives with different centers' do
    let(:primitive1 ){ described_class.new(zeta1,momenta1,center1)}
    let(:primitive2 ){ described_class.new(zeta2,momenta2,center2)}

    it 'should not have overlap of 0' do
      primitive1.overlap(primitive2).should be_within(1e-5).of(0)
    end
  end

  describe 'px and py primitives with zeta = 1.0, 1 Bohr translated' do
    let(:zeta1){1.0}
    let(:zeta2){1.0}
    let(:momenta1){[1,0,0]}
    let(:momenta2){[0,1,0]}
    let(:center1){[0,0,0]}
    let(:center2){[0,0,1]}
    it_behaves_like 'mutually orthogonal p primitives with different centers'
  end

  describe 'py and pz primitives with zeta = 1.0, 1 Bohr translated' do
    let(:zeta1){1.0}
    let(:zeta2){1.0}
    let(:momenta1){[0,1,0]}
    let(:momenta2){[0,0,1]}
    let(:center1){[0,0,0]}
    let(:center2){[0,0,1]}
    it_behaves_like 'mutually orthogonal p primitives with different centers'
  end

  describe 'pz and px primitives with zeta = 1.0, 1 Bohr translated' do
    let(:zeta1){1.0}
    let(:zeta2){1.0}
    let(:momenta1){[0,0,1]}
    let(:momenta2){[1,0,0]}
    let(:center1){[0,0,0]}
    let(:center2){[0,0,1]}
    it_behaves_like 'mutually orthogonal p primitives with different centers'
  end

  shared_examples_for 'two s primitives on different centers' do
    let(:primitive1){described_class.new(zeta1,[0,0,0],center1)}
    let(:primitive2){described_class.new(zeta2,[0,0,0],center2)}
    let(:primitive3){described_class.new(zeta2,[0,0,0],center1)}
    let(:r){primitive1.center-primitive2.center}
    let(:r2){r.inner_product(r)}
    let(:zeta){zeta1 * zeta2 / (zeta1 + zeta2)}

    describe 'overlap' do
      it 'should be scaled by exponential of displacement' do
        primitive1.overlap(primitive2).should be_within(1e-5).of(
          primitive1.overlap(primitive3) *
          Math::exp(-r2 * zeta))
      end
    end

    describe 'kinetic' do
      it 'should be scaled properly' do
        primitive1.kinetic(primitive2).should be_within(1e-5).of(
          primitive1.overlap(primitive2) * 
          (3*zeta - 2*r2*zeta**2))
      end
    end
  end

  describe 's primitives with zeta=1.0 on (0,0,0) and (0,0,1)' do
    let(:zeta1){1.0}
    let(:zeta2){1.0}
    let(:center1){[0,0,0]}
    let(:center2){[0,0,1]}
    it_behaves_like 'two s primitives on different centers'
  end
end

describe RuPHY::AO::Gaussian::Contracted do
  let(:coeffs){[1.0,0.0]}
  let(:zetas){[1.0,2.0]}
  let(:momenta){[0,0,0]}
  let(:center){Vector[0,0,0]}

  subject{described_class.new coeffs, zetas, momenta, center}

  context 'with proper coeffs, zetas, momenta, and center' do
    creating_it{should_not raise_error}
  end

  context 'with invalid zetas' do
    let(:zetas){[:wrong_zeta]}

    creating_it{should raise_error ArgumentError, /wrong_zeta.*out of zetas cannot be converted to Float!/}
  end
end
