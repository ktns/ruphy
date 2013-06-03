require 'spec_helper'
require 'ruphy/basisset/STO3G'
require 'ruphy/mo/basis/lcao'

describe RuPHY::MO::Basis::LCAO do
  context 'with TestMol and STO3G', :if => ::TestMol do
    let(:basis){described_class.new(::TestMol, RuPHY::BasisSet::STO3G)}
    subject{basis}

    it{should be_kind_of RuPHY::MO::Basis}

    describe '#aos' do
      def subject; super.aos; end

      it{should be_kind_of Enumerable}

      it{should all_be_kind_of RuPHY::AO}
    end

    shared_examples_for "operator represented by basis" do
      let(:matrix){ basis.__send__(operator) }
      subject{matrix}

      it{should be_kind_of RuPHY::Matrix}

      it{should be_square}

      it 'should not calculate symmetric off-diagonal element twice' do
        count = 0
        basis.aos.each do |ao|
          ao.stub(operator) do
            count += 1
          end
        end
        subject
        expect(count).to eq 3
      end

      describe 'diagonal elements' do
        subject{matrix.diagonal_elements}

        it{should all_be_within(1e-5).of(correct_diagonal_value)}
      end

      describe 'off diagonal elements' do
        subject{matrix.each :off_diagonal}

        it{should all_be_within(0.01).percent_of(correct_off_diagonal_value)}
      end
    end

    describe '#overlap' do
      let(:operator){:overlap}
      let(:correct_diagonal_value){1.0}
      let(:correct_off_diagonal_value){0.65987312}
      it_should_behave_like "operator represented by basis"
    end

    describe '#kinetic' do
      let(:operator){:kinetic}
      let(:correct_diagonal_value){0.76003188}
      let(:correct_off_diagonal_value){0.23696027}
      it_should_behave_like "operator represented by basis"
    end

    describe '#core_hamiltonian' do
      let(:operator){:core_hamiltonian}
      let(:correct_diagonal_value){0.76003188}
      let(:correct_off_diagonal_value){0.23696027}
      pending do
        it_should_behave_like "operator represented by basis"
      end
    end
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
