require 'spec_helper'

describe RuPHY::AO do
  describe '.new' do
    subject{lambda{described_class.new}}

    it{should raise_error NoMethodError}
  end
end
