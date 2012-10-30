require File.join(File.dirname(__FILE__), %w'.. .. .. spec_helper.rb')
require 'ruphy/basisset/STO3G'
require 'ruphy/mo/basis/lcao'

describe RuPHY::MO::Basis::LCAO do
	describe '#initialize', :if => ::TestMol do
		subject{described_class.new(::TestMol, RuPHY::BasisSet::STO3G)}

		it{pending{should be_kind_of RuPHY::MO::Basis}}
	end
end
