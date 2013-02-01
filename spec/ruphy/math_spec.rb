require 'spec_helper'

describe RuPHY::Math do
  describe '.boys' do
    subject{described_class.boys(r,m)}

    context 'r=0,m=0' do
      let(:r){Float::EPSILON};let(:m){0}

      it {should be_within(1e-5).of(1)}
    end
  end
end
