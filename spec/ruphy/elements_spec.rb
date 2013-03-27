require 'spec_helper'

describe RuPHY::ElementsModule do
  subject do
    {}.extend described_class, RuPHY::ElementData::PreDefined
  end

  describe '#[]' do
    it 'should invoke get_elem_data' do
      subject.should_receive(:get_elem_data).and_return([0,:hoge,0])
      subject[:hoge]
    end
  end

  describe '#symbols' do
    def subject
      super.symbols
    end

    it{should_not include_a String}

    it{should_not include_a Numeric}

    it{should have_at_least(100).items}
  end

  describe '#[:H]' do
    def subject
      super[:H]
    end

    its(:m){should be_within(1).percent_of(RuPHY::Constants::Da)}
  end
end
