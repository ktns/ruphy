require File.join(File.dirname(__FILE__), %w'.. .. .. spec_helper.rb')

describe RuPHY::Geometry do
	describe '.read_xyzfile' do
		subject { described_class.read_xyzfile(__FILE__) }

		it 'should invoke Molecule.new(fname,:xyz)' do
			RuPHY::Geometry::Molecule.should_receive(:new).with(kind_of(IO),:xyz)
			subject
		end
	end
end

describe RuPHY::Geometry::Molecule do
	describe '#initialize' do
		context 'with :xyz' do
			it "should extend molecule with #{RuPHY::Geometry::Reader::XYZ}" do
				RuPHY::Geometry::Reader::XYZ.should_receive(:extended)
				begin
					RuPHY::Geometry::Molecule.new(StringIO.new(""), :xyz)
				rescue NotImplementedError
				end
			end
		end
	end
end
