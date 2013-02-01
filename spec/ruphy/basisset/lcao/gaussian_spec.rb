require 'spec_helper'
require 'ruphy/basisset/lcao/gaussian'

describe RuPHY::BasisSet::LCAO::Gaussian do
  subject{described_class.new arg}

  shared_examples_for :proper_basisset do
    creating_it{should_not raise_error}
  end

  context 'with :H' do
    let(:arg){{:H=>stub(:HShells)}}

    it_should_behave_like :proper_basisset
  end

  context 'with :hoge' do
    let(:arg){{:hoge=>stub(:HeShells)}}

    creating_it{should raise_error described_class::InvalidElementError}
  end
end
