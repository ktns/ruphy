require 'spec_helper'

describe RuPHY::ElementsClass do
  subject do
    described_class.new.extend RuPHY::ElementData::PreDefined
  end

  describe '#[]' do
    it 'should invoke get_elem_data' do
      expect(subject).to receive(:get_elem_data).and_return([0,:hoge,0])
      subject[:hoge]
    end
  end

  describe '#symbols' do
    def subject
      super.symbols
    end

    it{is_expected.not_to include_a String}

    it{is_expected.not_to include_a Numeric}

    it{is_expected.to have_at_least(100).items}
  end

  describe '#[:H]' do
    def subject
      super[:H]
    end

    its(:m){should be_within(1).percent_of(RuPHY::Constants::Da)}
  end
end
