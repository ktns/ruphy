require File.join(File.dirname(__FILE__), %w|.. .. .. spec_helper.rb|)
require 'ruphy/basisset/lcao/gaussian'

describe RuPHY::BasisSet::LCAO::Gaussian do
  subject{described_class.new arg}

  context 'with :H' do
    let(:arg){{:H=>stub(:HShells)}}

    creating_it{should_not raise_error}
  end

  context 'with :hoge' do
    let(:arg){{:hoge=>stub(:HeShells)}}

    creating_it{should raise_error described_class::InvalidElementError}
  end
end
