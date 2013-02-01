require 'spec_helper'

describe 'RuPHY::Elements' do
  subject do
    RuPHY::Elements
  end
  describe '#[]' do
    it 'should invoke get_elem_data' do
      subject.should_receive(:get_elem_data).and_return([0,:hoge,0])
      RuPHY::Elements[:hoge] 
    end
  end

  describe '#symbols' do
    subject do
      RuPHY::Elements.symbols
    end

    it{should_not include_a String}

    it{should_not include_a Numeric}

    it{should have_at_least(100).items}
  end
end
