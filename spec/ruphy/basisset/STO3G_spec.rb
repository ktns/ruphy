require 'spec_helper'
require 'ruphy/basisset/STO3G'

describe "RuPHY::BasisSet::STO3G" do
  let(:described_class){RuPHY::BasisSet::STO3G}
  subject{described_class}

  it{should be_kind_of RuPHY::BasisSet::LCAO::Gaussian}

  it{should be_frozen}

  it{should respond_to :shells}

  describe '#shells' do
    subject{described_class.shells(arg)}

    context "with #{RuPHY::Element}" do
      let(:arg){random_element(1..RuPHY::Elements[:I].z)}
      
      calling_it{should_not raise_error}
    end

    context "with #{RuPHY::Element}.z" do
      let(:arg){random_element(1..RuPHY::Elements[:I].z).z}

      calling_it{should_not raise_error}
    end

    context "with #{RuPHY::Element}.to_s" do
      let(:arg){random_element(1..RuPHY::Elements[:I].z).to_s}

      calling_it{should_not raise_error}
    end

    context "with #{RuPHY::Element}.to_sym" do
      let(:arg){random_element(1..RuPHY::Elements[:I].z).to_sym}

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
