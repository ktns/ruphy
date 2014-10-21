require 'spec_helper'

describe RuPHY::Constants do
  it 'should define Da' do
    expect(described_class::Da).to be_kind_of Numeric
  end
end
