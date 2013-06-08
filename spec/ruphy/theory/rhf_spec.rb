require 'spec_helper'
require 'ruphy/basisset/STO3G'

describe RuPHY::Theory::RHF do
  describe 'on Helium atom' do
    it 'should yield -2.859895425 hartree of total energy'
  end
end

describe RuPHY::Theory::RHF::MO do
  let(:mo){described_class.new(*arg)}
  subject{mo}

  if defined? ::TestMol && defined? RuPHY::BasisSet::STO3G
    context "with #{::TestMol} and #{RuPHY::BasisSet::STO3G}" do
      let(:arg){[::TestMol, RuPHY::BasisSet::STO3G]}

      creating_it{pending{should_not raise_error}}
    end
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
