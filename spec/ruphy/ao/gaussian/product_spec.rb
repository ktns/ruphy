require 'spec_helper'

describe RuPHY::AO::Gaussian::Primitive::PrimitiveProduct do
  let(:center1){random_vector}
  let(:center2){random_vector}
  let(:zeta1){random_positive}
  let(:zeta2){random_positive}
  let(:primitive1){double(:primitive1, :zeta => zeta1, :center => center1)}
  let(:primitive2){double(:primitive2, :zeta => zeta2, :center => center2)}
  let(:p){zeta1+zeta2}
  let(:pa){(center1*zeta1+center2*zeta2)/(zeta1+zeta2) - center1}
  let(:pb){(center1*zeta1+center2*zeta2)/(zeta1+zeta2) - center2}
  let(:product) do
    described_class.new(primitive1,primitive2)
  end

  describe '#hermitian_coeff_decomposed' do
    context 'with i=0,j=0' do
      let(:i){0}
      let(:j){0}
      context 't = 0' do
        let(:t){0}
        subject{(0..2).map{|xyz| product.E(t,i,j,xyz)}}

        it{is_expected.to all be_within(1e-5).of(1)}
      end

      context 't > 0' do
        subject{(1..8).flat_map{|t|(0..2).map{|xyz| product.E(t,i,j,xyz)}}}

        it{is_expected.to all be_within(1e-5).of(0)}
      end
    end
    let(:i){rand(1..1)}
    let(:j){rand(1..1)}

    if defined? GSL
      shared_context 'contracted with Hermite polynomials' do
        include Math
        subject{(0..i+j).map{|t|GSL::Poly::hermite(t).to_f*sqrt(p)**(t) * product.E(t,i,j,xyz)}.reduce(&:+)} # \sum^{i+j}_t=0 E^{ij}_t H_t(X) sqrt(p)^t
        let(:cartesian_monomial1){([GSL::Poly[pa[xyz], 1.0/sqrt(p)]]*i).reduce(&:*)} # (x-A_x)^i = (x-P_x+PA_x)^i = (X/sqrt(p) + PA_x)^i
        let(:cartesian_monomial2){([GSL::Poly[pb[xyz], 1.0/sqrt(p)]]*j).reduce(&:*)} # (x-B_x)^j = (x-P_x+PB_x)^j = (X/sqrt(p) + PB_x)^j
        it{is_expected.to eq cartesian_monomial1*cartesian_monomial2}
      end

      context 'for x direction' do
        let(:xyz){0}

        include_context 'contracted with Hermite polynomials'
      end

      context 'for y direction' do
        let(:xyz){1}

        include_context 'contracted with Hermite polynomials'
      end

      context 'for z direction' do
        let(:xyz){2}

        include_context 'contracted with Hermite polynomials'
      end
    end
  end

  describe '#center' do
    subject{ product.center }

    it{is_expected.to eq((center1 * primitive1.zeta + center2 * primitive2.zeta) / (primitive1.zeta + primitive2.zeta))}
  end

  describe '#auxiliary_hermite_integral' do
    let(:i){{:X => 0, :Y => 1, :Z => 2}}
    let(:r){random_vector}

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

    let(:primitives){Array.new(4){random_primitive}}
    let(:products){primitives.each_slice(2).map{|p1,p2|p1*p2}}
    let(:p1){products.first}
    let(:p2){products.last}
    it 'should be commutable' do
      expect(p1.electron_repulsion_integral(p2)).to be_within(1e-3).percent_of(
        p2.electron_repulsion_integral(p1)
      )
    end
  end
end

describe RuPHY::AO::Gaussian::Contracted::Product do
  context 'with only one primitive' do
    let(:primitive_aos){4.times.map{random_primitive}}
    let(:contracted_aos){primitive_aos.map{|p| RuPHY::AO::Gaussian::Contracted::PrimitiveDummy.new(p)}}
    let(:primitive_products){primitive_aos.each_slice(2).map{|p1,p2|p1*p2}}
    let(:contracted_products){contracted_aos.each_slice(2).map{|c1,c2|c1*c2}}

  describe '#electron_repulsion' do
      it 'should return normalized PrimitiveProduct#electron_repulsion_integral' do
        expect(contracted_products[0].electron_repulsion(contracted_products[1])).to be_within(1e-3).percent_of(
          primitive_products[0].electron_repulsion_integral(primitive_products[1]) *
          primitive_aos.reduce(1){|n, p| n * p.normalization_factor}
        )
      end
    end
  end
end
