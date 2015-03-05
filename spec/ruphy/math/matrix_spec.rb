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
end
