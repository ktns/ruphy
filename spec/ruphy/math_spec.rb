require 'spec_helper'

describe RuPHY::Math do
  include described_class

  describe '#boys(r, n)' do
    subject{boys(r, n)}
    context 'r = 0' do
      let(:r){0}

      for n in 0..8
        let(:n){n}
        context 'n=%d' % n do
          it{should be_within(1e-11).of(1.0/(2*n+1))}
        end
      end
    end

    context 'n=0' do
      let(:n){0}

      context 'r -> +0' do
        let(:r){Float::EPSILON}
        it{should be_within(1e-11).of(1)}
      end
    end

    context 'with n:Float' do
      let(:n){1.5}; let(:r){1.0}
      calling_it{should raise_error ArgumentError}
    end

    context 'with n:negative' do
      let(:n){-1}; let(:r){1.0}
      calling_it{should raise_error ArgumentError, /negative/i}
    end
  end
end
