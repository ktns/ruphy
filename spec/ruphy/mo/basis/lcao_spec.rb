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

    describe '#overlap' do
      def subject; super.overlap; end

      it{should be_kind_of RuPHY::Matrix}

      it{should be_square}

      it 'should not calculate symmetric off-diagonal element twice' do
        pending do
          count = 0
          basis.aos.each do |ao|
            ao.stub(:overlap) do
              count += 1
            end
          end
          subject
          expect(count).to eq 3
        end
      end

      describe 'diagonal elements' do
        def subject; super.diagonal_elements; end

        it{should all_be_within(1e-5).of(1)}
      end

      describe 'off diagonal elements' do
        def subject; super.each :off_diagonal ; end

        it{should all_be_within(0.01).percent_of(0.65987312)}
      end
    end

    describe '#kinetic' do
      def subject; super.kinetic; end

      it{should be_kind_of RuPHY::Matrix}

      it{should be_square}

      it 'should not calculate symmetric off-diagonal element twice' do
        pending do
          count = 0
          basis.aos.each do |ao|
            ao.stub(:kinetic) do
              count += 1
            end
          end
          subject
          expect(count).to eq 3
        end
      end

      describe 'diagonal elements' do
        def subject; super.diagonal_elements; end

        it{should all_be_within(1e-5).of(0.76003188)}
      end

      describe 'off diagonal elements' do
        def subject; super.each(:off_diagonal) ; end

        it{should all_be_within(0.01).percent_of(0.23696027)}
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
