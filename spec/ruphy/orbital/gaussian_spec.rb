require File.join(File.dirname(__FILE__), %w'.. .. spec_helper.rb')

describe RuPHY::Orbital::Gaussian do

end

describe RuPHY::Orbital::Gaussian::Primitive do
	describe '.new' do
		it 'should accept zeta, momenta, and center' do
			lambda do
				described_class.new 1.0, [0,0,0], Vector[0,0,0]
			end.should_not raise_error
		end

		it 'should not accept wrong dimension of momenta' do
			lambda do
				described_class.new 1.0, [0,0,0,0], Vector[0,0,0]
			end.should raise_error ArgumentError
		end

		it 'should not accept wrong dimension of center coordinates' do
			lambda do
				described_class.new 1.0, [0,0,0], Vector[0,0,0,0]
			end.should raise_error ArgumentError
		end
	end

	shared_examples_for 'a primitive'	do
		subject do
			described_class.new(zeta,momenta,center)
		end

		its(:zeta){ should be_frozen }

		its(:momenta){ should be_frozen }

		its(:center){ should be_frozen }

		its(:normalization_factor) do
			should be_within(1e-5).of(
				(2/Math::PI)**0.75*
				2**momenta.reduce(:+)*
				zeta**((2*momenta.reduce(:+)+3).to_f/4)/
				momenta.map do |m|
				m==0 ? 1 :
					(2*m-1).downto(1).reduce(:*).downto(1).reduce(:*)
				end.reduce(:*)**0.5
			)
		end

		its(:angular_momentum) do
			should == momenta.reduce(:+)
		end
	end

	describe 's orbital with zeta = 1.0' do
		let(:zeta){1.0}
		let(:momenta){[0,0,0]}
		let(:center){[0,0,0]}
		it_behaves_like 'a primitive'
	end

	describe 'px orbital with zeta = 1.0' do
		let(:zeta){1.0}
		let(:momenta){[1,0,0]}
		let(:center){[0,0,0]}
		it_behaves_like 'a primitive'
	end

	describe 'py orbital with zeta = 1.0' do
		let(:zeta){1.0}
		let(:momenta){[0,1,0]}
		let(:center){[0,0,0]}
		it_behaves_like 'a primitive'
	end

	describe 'pz orbital with zeta = 1.0' do
		let(:zeta){1.0}
		let(:momenta){[0,0,1]}
		let(:center){[0,0,0]}
		it_behaves_like 'a primitive'
	end

	describe 'dxy orbital with zeta = 1.0' do
		let(:zeta){1.0}
		let(:momenta){[1,1,0]}
		let(:center){[0,0,0]}
		it_behaves_like 'a primitive'
	end

	describe 'dyz orbital with zeta = 1.0' do
		let(:zeta){1.0}
		let(:momenta){[0,1,1]}
		let(:center){[0,0,0]}
		it_behaves_like 'a primitive'
	end

	describe 'dzx orbital with zeta = 1.0' do
		let(:zeta){1.0}
		let(:momenta){[1,0,1]}
		let(:center){[0,0,0]}
		it_behaves_like 'a primitive'
	end

	describe 'dx^2 orbital with zeta = 1.0' do
		let(:zeta){1.0}
		let(:momenta){[2,0,0]}
		let(:center){[0,0,0]}
		it_behaves_like 'a primitive'
	end

	describe 'dy^2 orbital with zeta = 1.0' do
		let(:zeta){1.0}
		let(:momenta){[0,2,0]}
		let(:center){[0,0,0]}
		it_behaves_like 'a primitive'
	end

	describe 'dz^2 orbital with zeta = 1.0' do
		let(:zeta){1.0}
		let(:momenta){[0,0,2]}
		let(:center){[0,0,0]}
		it_behaves_like 'a primitive'
	end
end

describe RuPHY::Orbital::Gaussian::Contracted do
	describe '.new' do
		it 'should accept coeffs, zetas, momenta, and center' do
			lambda do
				described_class.new [1.0,0.0], [1.0,2.0], [0,0,0], Vector[0,0,0]
			end.should_not raise_error
		end
	end
end
