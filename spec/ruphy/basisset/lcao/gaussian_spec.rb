require 'spec_helper'
require 'ruphy/basisset/lcao/gaussian'

describe RuPHY::BasisSet::LCAO::Gaussian do
  subject{described_class.new arg}

  shared_examples_for :proper_basisset do
    creating_it{should_not raise_error}
    it{should respond_to :shells}

    describe "#shells" do
      context "with H atom" do
        let(:atom){dummy_atom(0,0,0,1)}
        def subject
          super.shells(atom)
        end

        it{should be_kind_of Enumerable}

        it{should all_be_kind_of described_class::Shell}
      end
    end
  end

  let(:hshells) do
    extend RSpec::Mocks::ExampleMethods
    hshell = double(:HShell)
    hshell.stub(:kind_of?).with(described_class::Shell).and_return(true)
    described_class::Shell.stub(:===).with(hshell).and_return(true)
    break [hshell]
  end

  let(:heshells) do
    extend RSpec::Mocks::ExampleMethods
    heshell = double(:HeShell)
    heshell.stub(:kind_of?).and_return(true)
    break [heshell]
  end

  context 'with :H' do
    let(:arg){{:H=>hshells}}

    it_should_behave_like :proper_basisset
  end

  context 'with :hoge' do
    let(:arg){{:hoge=>heshells}}

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
