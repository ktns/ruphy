require File.join(File.dirname(__FILE__), %w|.. .. .. spec_helper.rb|)
require 'ruphy/basisset/lcao/gaussian'

describe RuPHY::BasisSet::LCAO::Gaussian::Shell do
	describe '::CartAngularMomentumBasis' do
		subject{RuPHY::BasisSet::LCAO::Gaussian::Shell::CartAngularMomentumBasis}

		it{should be_frozen}

		it{should be_all(&:frozen?)}

		its(:size){should eq 3}
	end

	describe '.cart_angular_momenta' do
		subject{described_class.cart_angular_momenta(l)}
		context 'l=0' do
			let(:l){0}

			it{should eq [Vector[0,0,0]]}

			it{should be_frozen}
		end

		context 'l=1' do
			let(:l){1}

			its(:size){should eq 3}

			it{should include Vector[1,0,0]}
			it{should include Vector[0,1,0]}
			it{should include Vector[0,0,1]}

			it{should be_frozen}
		end

		context 'l=2' do
			let(:l){2}

			its(:size){should eq 6}

			it{should include Vector[2,0,0]}
			it{should include Vector[0,2,0]}
			it{should include Vector[0,1,1]}
			it{should include Vector[1,0,1]}
			it{should include Vector[1,1,0]}

			it{should be_frozen}
		end
	end
end
