require 'spec_helper'

describe RuPHY::AO do
  describe '.new' do
    subject{lambda{described_class.new}}

    it{is_expected.to raise_error NoMethodError}
  end
end
