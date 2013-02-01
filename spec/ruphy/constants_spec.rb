require 'spec_helper'

describe RuPHY::Constants do
  it 'should define Da' do
    described_class::Da.should be_kind_of Numeric
  end
end
