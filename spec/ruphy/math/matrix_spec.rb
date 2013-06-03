require 'spec_helper'

describe RuPHY::Math::Matrix do
  describe '#build' do
    subject{described_class.build(1){1}}

    it{should be_kind_of described_class}
  end
end
