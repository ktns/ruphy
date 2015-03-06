require 'spec_helper'

describe RuPHY::Math::Matrix, matrix: true do
  describe '#build' do
    subject{described_class.build(1){1}}

    it{is_expected.to be_kind_of described_class}
  end

  describe '#diagonal_elements' do
    let(:size){rand(5)+1}
    let(:matrix){described_class.build(size){rand()}}
    subject{matrix.diagonal_elements}

    its(:count){is_expected.to eq size}
  end

  shared_examples_for 'operator between matrices' do
    let(:matrixA){described_class.build(1){1}}
    let(:matrixB){described_class.build(1){1}}
    subject{matrixA.__send__(operator,matrixB)}

    it{is_expected.to be_kind_of described_class}
  end

  describe '#+' do
    let(:operator){:+}
    it_should_behave_like 'operator between matrices'
  end

  describe '#-' do
    let(:operator){:-}
    it_should_behave_like 'operator between matrices'
  end

  shared_examples_for 'operator between a scalar and a matrix' do
    let(:matrix){described_class.build(1){1}}
    let(:scalar){rand()}
    subject{scalar.__send__(operator,matrix)}

    it{is_expected.to be_kind_of described_class}
  end

  shared_examples_for 'operator between a matrix and a scalar' do
    let(:matrix){described_class.build(1){1}}
    let(:scalar){rand()}
    subject{matrix.__send__(operator,scalar)}

    it{is_expected.to be_kind_of described_class}
  end

  describe '#*' do
    let(:operator){:*}
    it_should_behave_like 'operator between matrices'
    it_should_behave_like 'operator between a scalar and a matrix'
    it_should_behave_like 'operator between a matrix and a scalar'
  end

  shared_examples_for 'a predicate method' do
    specify 'is expected to return true for positive examples' do
      for e in (positive_examples rescue skip 'no positive examples')
        expect(e.send(predicate, *(args rescue []))).to be_truthy
      end
    end

    specify 'is expected to return false for negative examples' do
      for e in (negative_examples rescue skip 'no negative examples')
        expect(e.send(predicate, *(args rescue []))).to be_falsy
      end
    end
  end

  describe '#square?' do
    let(:predicate){:square?}
    let(:positive_examples){[described_class.identity(rand(1..8))]}
    let(:negative_examples){[described_class[[1,2]]]}
    include_context 'a predicate method'
  end

  describe 'as a collection' do
    let(:size){rand(5)+1}
    let(:matrix){described_class.build(size){rand()}}
    subject{matrix}

    it{is_expected.to all(be_finite)}
  end
end
