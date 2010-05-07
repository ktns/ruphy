require File.dirname(__FILE__) + '/spec_helper'

$:.unshift File.dirname(__FILE__) + "/../ext/ruphy_gsl"
require "ruphy_gsl.so"

describe "ruphy_gsl" do
	it "should define module RuPHY::GSL" do
		RuPHY::GSL.should be_instance_of(Module)
	end

	it 'should define module RuPHY::GSL::SPWF' do
		RuPHY::GSL::SPWF.should be_instance_of(Module)
	end

	it 'should define class RuPHY::GSL::SPWF::Hydrogenic' do
		RuPHY::GSL::SPWF::Hydrogenic.should be_instance_of(Class)
	end

	it 'should define module RuPHY::GSL::SPOP' do
		RuPHY::GSL::SPOP.should be_instance_of(Module)
	end

	it 'should define module RuPHY::GSL::SPOP::Hamiltonian' do
		RuPHY::GSL::SPOP::Hamiltonian.should be_instance_of(Module)
	end

	it 'should define class RuPHY::GSL::SPOP::Hamiltonian::Hydrogenic' do
		RuPHY::GSL::SPOP::Hamiltonian::Hydrogenic.should be_instance_of(Class)
	end
end

describe RuPHY::GSL::SPWF::Hydrogenic do
	it 'should be descendant of SPWF' do
		RuPHY::GSL::SPWF::Hydrogenic.should < RuPHY::GSL::SPWF
	end
end

describe RuPHY::GSL::SPOP::Hamiltonian do
	it 'should be descendant of SPOP' do
		RuPHY::GSL::SPOP::Hamiltonian.should < RuPHY::GSL::SPOP
	end
end

describe RuPHY::GSL::SPOP::Hamiltonian::Hydrogenic do
	it 'should be descendant of Hamiltonian' do
		RuPHY::GSL::SPOP::Hamiltonian::Hydrogenic.should < RuPHY::GSL::SPOP::Hamiltonian
	end
end

describe RuPHY::GSL::SPOP do
	describe '.test_deriv_r' do
		it 'should return 1' do
			[0.0, 1.0, -1.0, 10.0, -10.0].each do |f|
				RuPHY::GSL::SPOP.test_deriv_r(f).should be_close(1.0, 1e-6);
			end
		end
	end
end
