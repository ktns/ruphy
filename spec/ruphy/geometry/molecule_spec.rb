require File.join(File.dirname(__FILE__), %w'.. .. spec_helper.rb')

describe RuPHY::Geometry::Molecule do
	describe 'read from xyz file' do
		it 'should have proper atom count'
	end
end

describe RuPHY::Geometry::Molecule::Atom do
	describe '#initialize' do
		subject do
			described_class.new(elem, x, y, z)
		end

		context '@(0,0,0)' do
			let(:x){0}; let(:y){0}; let(:z){0};

			context 'with :H' do
				let(:elem){:H}
				it do
					should be_kind_of described_class
				end
			end

			context 'with 1' do
				let(:elem){1}
				it do
					should be_kind_of described_class
				end
			end

			context 'with Elements[:H]' do
				let(:elem){RuPHY::Elements[:H]}
				it do
					should be_kind_of described_class
				end
			end
		end
	end
end
