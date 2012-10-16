require File.join(File.dirname(__FILE__), %w|.. spec_helper.rb|)

describe RuPHY::Geometry::Molecule do
	context 'with xyz string' do
		let(:xyz) do
			<<-EOF
				3
				Oxidane
				H          0.63109       -0.02651        0.47485
				O          0.14793        0.02998       -0.34219
				H         -0.77901       -0.00348       -0.13266
				EOF
		end

		let(:correct_size){3}

		subject{described_class.new(xyz)}

		its(:size){should == correct_size}
	end
end
