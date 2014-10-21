require 'spec_helper'
require 'ruphy/basisset/STO3G'
require 'ruphy/mo/basis/lcao'

describe RuPHY::MO::Basis::LCAO do
  context 'with TestMol and STO3G', :if => ::TestMol do
    let(:basis){described_class.new(::TestMol, RuPHY::BasisSet::STO3G)}
    subject{basis}

    it{is_expected.to be_kind_of RuPHY::MO::Basis}

    describe '#aos' do
      def subject; super.aos; end

      it{is_expected.to be_kind_of Enumerable}

      it{is_expected.to all_be_kind_of RuPHY::AO}
    end

    shared_examples_for "operator represented by basis" do
      let(:matrix){ basis.__send__(operator) }
      subject{matrix}

      it{is_expected.to be_kind_of RuPHY::Matrix}

      it{is_expected.to be_square}

      it{is_expected.to all_be_finite}

      describe 'diagonal elements' do
        subject{matrix.diagonal_elements}

        it{is_expected.to all_be_within(1e-5).of(correct_diagonal_value)}
      end

      describe 'off diagonal elements' do
        subject{matrix.each :off_diagonal}

        it{is_expected.to all_be_within(0.01).percent_of(correct_off_diagonal_value)}
      end
    end

    shared_examples_for 'operator simply projected by basis' do
      let(:matrix){ basis.__send__(operator) }
      subject{matrix}

      it 'should not calculate symmetric off-diagonal element twice' do
        count = 0
        basis.aos.each do |ao|
          allow(ao).to receive(operator) do
            count += 1
          end
        end
        subject
        expect(count).to eq 3
      end
    end


    describe '#overlap' do
      let(:operator){:overlap}
      let(:correct_diagonal_value){1.0}
      let(:correct_off_diagonal_value){0.65987312}
      it_should_behave_like "operator represented by basis"
      it_should_behave_like 'operator simply projected by basis'
    end

    describe '#kinetic' do
      let(:operator){:kinetic}
      let(:correct_diagonal_value){0.76003188}
      let(:correct_off_diagonal_value){0.23696027}
      it_should_behave_like "operator represented by basis"
      it_should_behave_like 'operator simply projected by basis'
    end

    describe '#core_hamiltonian' do
      let(:operator){:core_hamiltonian}
      let(:correct_diagonal_value){-0.11209595e1}
      let(:correct_off_diagonal_value){-0.95937577}
      it_should_behave_like "operator represented by basis"
    end
  end
end

describe RuPHY::MO::Basis::LCAO::Shell do
  context 'with mockup center and abstract shell' do
    let(:center){double(:center)}
    let!(:abst_shell) do
      double(:abst_shell).tap do |abst_shell|
      allow(abst_shell).to receive(:respond_to?).with(:aos).and_return(true)
      end
    end

    subject{described_class.new(abst_shell, center)}

    its(:center){should == center}

    describe '#aos' do
      it "should invoke abst_shell#aos" do
        allow(abst_shell).to receive(:dup).and_return(abst_shell)
        expect(abst_shell).to receive(:aos).and_return(nil)
        subject.aos
      end
    end
  end
end
