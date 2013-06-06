if ENV['TEST_NIST']
  require 'spec_helper'
  require 'ruphy/elements/nist'

  #Override NIST methods with PreDefined methods
  #to avoid connections to remote host while other tests
  RuPHY::Elements.extend(RuPHY::ElementData::PreDefined.clone)

  describe RuPHY::ElementData::NIST do
    it 'should be included by RuPHY::Elements' do
      RuPHY::Elements.should be_kind_of described_class
    end

    subject do
      RuPHY::Elements.class.new.extend described_class
    end

    describe '#get_elem_data' do
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
          m.should be_within(1.0).percent_of(1)
        end
      end
    end
  end
end
