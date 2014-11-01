require 'spec_helper'

def random_primitive
  RuPHY::AO::Gaussian::Primitive.new(rand(),Array.new(3){rand(2)},random_vector)
end

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

  shared_examples_for 'a primitive'	do
    let(:primitive ){ described_class.new(zeta,momenta,center)}

    subject{primitive}

    its(:zeta){ is_expected.to be_frozen }

    its(:momenta){ is_expected.to be_frozen }

    its(:center){ is_expected.to be_frozen }

    describe '#normalization_factor' do
      subject{primitive.normalization_factor}

      it "should return correct value" do
        is_expected.to be_within(1e-5).of(
          momenta.inject(1.0) do |k,i|
            k*(1..2*i-1).step(2).inject(1,&:*)/2**i/(2*zeta)**i
          end**-0.5 * (Math::PI/2/zeta)**-0.75
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
end

describe RuPHY::AO::Gaussian::Primitive::PrimitiveProduct do
  let(:primitive1){mock_primitive(:primitive1)}
  let(:primitive2){mock_primitive(:primitive2)}
  let(:product){described_class.new(primitive1,primitive2)}

  describe '#hermitian_coeff_decomposed' do
    let(:xyz){double(:xyz)}
    let(:p){rand()};
    let(:pa){rand()}; let(:pb){rand()}

    def self.case_for t, i, j, val = nil, &block
      block and val = block

      def E(t,i,j)
        allow(product).to receive(:p).with(no_args).and_return(p)
        allow(product).to receive(:pa).with(no_args).and_return(mock_vector(pa,:pa,xyz))
        allow(product).to receive(:pb).with(no_args).and_return(mock_vector(pb,:pb,xyz))
        product.hermitian_coeff_decomposed(t,i,j,xyz)
      end

      context 'with t=%d, i=%d, j=%d' % [t,i,j] do
        subject do
          E(t,i,j)
        end

        it 'should calculated correctly' do
          case val
          when nil
            if i > 0
              is_expected.to be_within(1e-5).of(
                          E(t-1, i-1, j) / 2 / p \
                   + pa * E(t,   i-1, j)         \
                + (t+1) * E(t+1, i-1, j)
              )
            else
              is_expected.to be_within(1e-5).of(
                          E(t-1, i, j-1) / 2 / p \
                   + pb * E(t,   i, j-1)         \
                + (t+1) * E(t+1, i, j-1)
              )
            end
          when Proc
            is_expected.to be_within(1e-5).of(instance_eval(&val))
          else
            is_expected.to be_within(1e-5).of(val)
          end
        end

        it{is_expected.to be_a Float}
      end
    end

    case_for(0, 0, 0, 1)

    case_for(1, 0, 0, 0)

    case_for(0, 1, 0){pa}

    case_for(0, 0, 1){pb}

    case_for(0, 1, 1){pa*pb + E(1, 0, 1)}

    case_for(1, 1, 0){0.5/p}

    case_for(1, 0, 1){0.5/p}

    case_for(0, 0, 2){pb*E(0,0,1)+E(1,0,1)}

    case_for(0, 1, 2){pa*E(0,0,2)+E(1,0,2)}

    case_for(2, 0, 2){E(1,0,1)/2/p}

    case_for(1, 1, 2){E(0,0,2)/2/p+pa*E(1,0,2)+2*E(2,0,2)}

    case_for(0, 2, 2){pa*E(0,1,2)+E(1,1,2)}
  end

  describe '#center' do
    let(:center1){random_vector}
    let(:center2){random_vector}

    subject do
      allow(primitive1).to receive(:center).and_return(center1)
      allow(primitive2).to receive(:center).and_return(center2)
      product.center
    end

    it{is_expected.to eq((center1 * primitive1.zeta + center2 * primitive2.zeta) / (primitive1.zeta + primitive2.zeta))}
  end

  describe '#auxiliary_hermite_integral' do
    let(:i){{:X => 0, :Y => 1, :Z => 2}}
    let(:r){random_vector}
    let(:p){random_positive()}

    (0..2).to_a.repeated_permutation(4) do  |t1, u1, v1, n|
      context do
        let(:tuv1){[t1,u1,v1]}
        for dir in [:X, :Y, :Z]
          context '' % [t1, u1, v1, n] do
            describe "#{dir} directonal recurrence relation" do
              it 'is expected be satsfied on (t1=%d, u1=%d, v1=%d, n=%d)' % [t1, u1, v1, n] do
                tuv2=tuv1.dup
                tuv2[i[dir]]+=1
                t2, u2, v2 = tuv2

                tuv0=tuv1.dup
                tuv0[i[dir]]-=1
                t0, u0, v0 = tuv0
                expect(          product.auxiliary_hermite_integral(t2, u2, v2, n,   p, r)).to be_within(1e-2).percent_of(
                  tuv1[i[dir]] * product.auxiliary_hermite_integral(t0, u0, v0, n+1, p, r) +
                     r[i[dir]] * product.auxiliary_hermite_integral(t1, u1, v1, n+1, p, r)
                )
              end
            end
          end
        end
      end
    end
  end

  describe '#electron_repulsion_integral' do
    context 'with primitives zeta = 1 and all on same center' do
      let(:primitive){RuPHY::AO::Gaussian::Primitive.new(1,[0,0,0],[0,0,0])}
      let(:product){primitive*primitive}
      let(:correct_value){Math::PI**2.5/4}
      subject{product.electron_repulsion_integral(product)}

      it{is_expected.to eq correct_value}
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

describe RuPHY::AO::Gaussian::Contracted::Product do
  let(:primitive){RuPHY::AO::Gaussian::Primitive.new(1,[0,0,0],[0,0,0])}
  let(:contracted){RuPHY::AO::Gaussian::Contracted::PrimitiveDummy.new(primitive)}
  describe '#electron_repulsion' do
    let(:correct_value){Math::PI**2.5/4 * primitive.normalization_factor**4}

    it 'should yield correct value' do
      expect((contracted*contracted).electron_repulsion(contracted*contracted)).to be_within(1e-5).of(correct_value)
    end
  end
end
