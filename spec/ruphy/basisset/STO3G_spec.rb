require 'spec_helper'
require 'ruphy/basisset/STO3G'

describe "RuPHY::BasisSet::STO3G" do
  subject{RuPHY::BasisSet::STO3G}

  it{should be_kind_of RuPHY::BasisSet::LCAO::Gaussian}

  it{should be_frozen}

  it{should respond_to :shells}

  describe '#shells' do
    def subject; super.shells(arg); end

    context "with #{RuPHY::Element}" do
      let(:arg){random_element}
      
      calling_it{should_not raise_error}
    end

    context "with #{RuPHY::Element}.z" do
      let(:arg){random_element.z}

      calling_it{should_not raise_error}
    end

    context "with #{RuPHY::Element}.to_s" do
      let(:arg){random_element.to_s}

      calling_it{should_not raise_error}
    end

    context "with #{RuPHY::Element}.to_sym" do
      let(:arg){random_element.to_sym}

      calling_it{should_not raise_error}
    end

    context "with #{RuPHY::Geometry::Atom}", :if => ::TestMol do
      let(:arg){::TestMol.each_atom.first}
      
      calling_it{should_not raise_error}
    end

    context "with #{:hoge}" do
      let(:arg){:hoge}

      calling_it{should raise_error TypeError}
    end
  end
end
