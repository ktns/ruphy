if ENV['TEST_NIST']
  require 'spec_helper'
  require 'ruphy/elements/nist'

  describe RuPHY::ElementData::NIST do
    it 'should be included by RuPHY::Elements' do
      RuPHY::Elements.should be_kind_of described_class
    end

    describe '#get_elem_data' do
      subject do
        stub(:get_elem_data).extend described_class
      end

      context 'with H' do
        let(:hdat){subject.send(:get_elem_data,:H)}
        let(:z){hdat[0]}
        let(:sym){hdat[1]}
        let(:m){hdat[2]}

        it 'should return proper atomic number' do
          z.should == 1
        end

        it 'should return proper atomic symbol' do
          sym.should == :H
        end

        it 'should return proper atomic weight' do
          m.should be_within(0.01).of(1)
        end
      end
    end
  end
end
