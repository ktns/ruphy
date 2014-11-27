require 'spec_helper'

describe RuPHY::AO::Gaussian do

end

describe RuPHY::AO::Gaussian::Primitive do
  describe '.new' do
    it 'should accept zeta, momenta, and center' do
      expect do
        described_class.new 1.0, [0,0,0], Vector[0,0,0]
      end.not_to raise_error
    end

    it 'should not accept wrong dimension of momenta' do
      expect do
        described_class.new 1.0, [0,0,0,0], Vector[0,0,0]
      end.to raise_error ArgumentError
    end

    it 'should not accept wrong dimension of center coordinates' do
      expect do
        described_class.new 1.0, [0,0,0], Vector[0,0,0,0]
      end.to raise_error ArgumentError
    end
  end

  let(:primitive ){ described_class.new(zeta,momenta,center)}

  shared_examples_for 'a primitive'	do
    subject{primitive}

    its(:zeta){ is_expected.to be_frozen }

    its(:momenta){ is_expected.to be_frozen }

    its(:center){ is_expected.to be_frozen }

    describe '#normalization_factor' do
      subject{primitive.normalization_factor}

      it "should return correct value" do
        p = 2*zeta
        is_expected.to be_within(1e-5).of(
          momenta.inject(1.0) do |k,i| # \int x^2i exp(-2zeta*x^2)
            k*(1..2*i-1).step(2).inject(1,&:*)/(2*p)**i # (2i-1)!!/(2*2zeta)^i
          end**-0.5 * (Math::PI/p)**-0.75
        )
      end
    end

    describe "its overlap with self" do
      subject{primitive.overlap(primitive)}

      it{is_expected.to be_within(0.1).percent_of(1)}
    end

    its(:angular_momentum) do
      is_expected.to eq momenta.reduce(:+)
    end

    describe 'diagonal kinetic integal' do
      subject{primitive.kinetic(primitive)}

      it {is_expected.not_to eq(0)}
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
      expect(primitive1.overlap(primitive2)).to be_within(1e-5).of(0)
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
      expect(primitive1.overlap(primitive2)).to be_within(1e-5).of(0)
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
        expect(primitive1.overlap(primitive2)).to be_within(1e-5).of(
          primitive1.overlap(primitive3) *
          Math::exp(-r2 * zeta))
      end
    end
  end

  describe 's primitives with zeta=1.0 on (0,0,0) and (0,0,1)' do
    let(:zeta1){1.0}
    let(:zeta2){1.0}
    let(:center1){[0,0,0]}
    let(:center2){[0,0,1]}
    let(:primitive1){described_class.new(zeta1,[0,0,0],center1)}
    let(:primitive2){described_class.new(zeta2,[0,0,0],center2)}
    let(:product){RuPHY::AO::Gaussian::Primitive::PrimitiveProduct.new(primitive1,primitive2)}
    it_behaves_like 'two s primitives on different centers'

    describe 'decomposed kinetic integral along z axis' do
      it 'should be correct' do
        expect(product.kinetic_decomposed(2)).to be_within(1e-5).of(0.0)
      end
    end

    describe 'raw kinetic integral' do

      it 'should be correct' do
        expect(primitive1.kinetic_raw(primitive2)).to be_within(1e-5).of(-2.388155327648917/-2)
      end
    end
  end

  describe '#shell_ao_normalization_factor_ratio' do
    context 'of dyz orbital' do
      let(:primitive){described_class.new(random_positive, [0,1,1], random_vector)}
      let(:reference){described_class.new(primitive.zeta, [0,0,2],primitive.center)}

      it 'should equals to dyz.normalization_factor/dzz.normalization_factor' do
        expect(primitive.shell_ao_normalization_factor_ratio).to be_within(1e-3).percent_of(
          primitive.normalization_factor/reference.normalization_factor
        )
      end
    end
  end
end

describe RuPHY::AO::Gaussian::Contracted do
  let(:coeffs){[1.0,0.0]}
  let(:zetas){[1.0,2.0]}
  let(:momenta){[0,0,0]}
  let(:center){Vector[0,0,0]}
  let(:contracted){described_class.new coeffs, zetas, momenta, center}

  subject{contracted}

  context 'with proper coeffs, zetas, momenta, and center' do
    creating_it{is_expected.not_to raise_error}
  end

  context 'with invalid zetas' do
    let(:zetas){[:wrong_zeta]}

    creating_it{is_expected.to raise_error ArgumentError, /wrong_zeta.*out of zetas cannot be converted to Float!/}
  end

  describe '#overlap' do
    subject{contracted.overlap(other)}

    context 'with self' do
      let(:other){contracted}

      it{is_expected.to be_a Float}
    end
  end
end

# specs for * method
describe RuPHY::AO::Gaussian::Primitive do
  describe '*' do
    let(:primitive1){random_primitive}
    context RuPHY::AO::Gaussian::Primitive do
      let(:primitive2){random_primitive}
      it 'should be a ' + RuPHY::AO::Gaussian::Primitive::PrimitiveProduct.to_s do
        expect(primitive1*primitive2).to be_a RuPHY::AO::Gaussian::Primitive::PrimitiveProduct
      end
    end

    context RuPHY::AO::Gaussian::Contracted do
      let(:contracted2){RuPHY::AO::Gaussian::Contracted::PrimitiveDummy.new(random_primitive)}
      it 'should be a ' + RuPHY::AO::Gaussian::Contracted::Product.to_s do
        expect(primitive1*contracted2).to be_a RuPHY::AO::Gaussian::Contracted::Product
      end
    end
  end
end

describe RuPHY::AO::Gaussian::Contracted do
  describe '*' do
    let(:contracted1){RuPHY::AO::Gaussian::Contracted::PrimitiveDummy.new(random_primitive)}
    context RuPHY::AO::Gaussian::Primitive do
      let(:primitive2){random_primitive}
      it 'should be a ' + RuPHY::AO::Gaussian::Contracted::Product.to_s do
        expect(contracted1*primitive2).to be_a RuPHY::AO::Gaussian::Contracted::Product
      end
    end

    context RuPHY::AO::Gaussian::Contracted do
      let(:contracted2){RuPHY::AO::Gaussian::Contracted::PrimitiveDummy.new(random_primitive)}
      it 'should be a ' + RuPHY::AO::Gaussian::Contracted::Product.to_s do
        expect(contracted1*contracted2).to be_a RuPHY::AO::Gaussian::Contracted::Product
      end
    end
  end
end
