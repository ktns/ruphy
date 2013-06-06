require 'spec_helper'

describe RuPHY::Theory::RHF do
  describe 'on Helium atom' do
    it 'should yield -2.859895425 hartree of total energy'
  end
end

describe RuPHY::Theory::RHF::Solver do
  it 'should not raise error on initialization' do
    pending 'Not yet implemented' do
      lambda do
        described_class.new nil, nil
      end.should_not raise_error
    end
  end
end
