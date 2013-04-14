require 'spec_helper'
require 'ruphy/basisset/STO3G'
require 'ruphy/mo/basis/lcao'

describe RuPHY::MO::Basis::LCAO do
  describe '#initialize', :if => ::TestMol do
    subject{described_class.new(::TestMol, RuPHY::BasisSet::STO3G)}

    it{pending{should be_kind_of RuPHY::MO::Basis}}
  end
end

describe RuPHY::MO::Basis::LCAO::Shell do
  context 'with mockup center and abstract shell' do
    let(:center){mock(:center)}
    let!(:abst_shell){mock(:abst_shell)}

    subject{described_class.new(abst_shell, center)}

    its(:center){should == center}

    describe '#aos' do
      it "should invoke abst_shell#aos" do
        abst_shell.stub!(:dup).and_return(abst_shell)
        abst_shell.should_receive(:aos).and_return(nil)
        subject.aos
      end
    end
  end
end
