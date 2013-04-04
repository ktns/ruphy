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

  context 'deserialized from YAML' do
    let(:comment){<<EOC
! TEST
! COMMENT
EOC
    }

    let(:original){described_class.new(:H => Object.new,
                                       :He => Object.new,
                                       :comment => comment)}

    subject{YAML.load(original.to_yaml)}

    its(:comment){should == original.comment}
    
    its(:elements){should == original.elements}
  end
end

describe RuPHY::BasisSet::LCAO::Gaussian::YAML::CommentStyle do
  example{expect{''.extend described_class}.not_to raise_error}

  example{expect{Object.new.extend described_class}.to raise_error(TypeError)}

  context 'with string' do
    let(:str){rand().to_s}

    subject{str.clone.extend described_class}

    its(:to_yaml){should_not include '!'}

    its(:to_yaml){should include str}
  end
end
