require File.dirname(__FILE__) + '/spec_helper'

$:.unshift File.dirname(__FILE__) + "/../ext/ruphy_gsl"
require "ruphy_gsl"

describe "ruphy_gsl" do
	it "should define module RuPHY::GSL" do
		RuPHY::GSL.should be_instance_of(Module)
	end

	it 'should define class RuPHY::GSL::GSLError' do
		RuPHY::GSL::GSLError.should be_instance_of(Class)
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
	if RuPHY::GSL::SPOP.respond_to? :test_deriv_r
		describe '.test_deriv_r' do
			it 'should return sane values' do
				[0.0, 1.0, -1.0, 10.0, -10.0].each do |f|
					RuPHY::GSL::SPOP.test_deriv_r(0,f).should be_close(1.0, 1e-6);
				end

				[0.0, 1.0, -1.0, 10.0, -10.0].each do |f|
					RuPHY::GSL::SPOP.test_deriv_r(1,f).should be_close(2*f, [(2*f*1e-6).abs,1e-6].max)
				end
			end
		end
	end

	if RuPHY::GSL::SPOP.respond_to? :test_deriv_theta
		describe '.test_deriv_theta' do
			it 'should return sane values' do
				[0.0, 1.0, -1.0, 10.0, -10.0].each do |f|
					RuPHY::GSL::SPOP.test_deriv_theta(0,f).should be_close(1.0, 1e-6);
				end

				[0.0, 1.0, -1.0, 10.0, -10.0].each do |f|
					RuPHY::GSL::SPOP.test_deriv_theta(1,f).should be_close(2*f, [(2*f*1e-6).abs,1e-6].max)
				end
			end
		end
	end

	if RuPHY::GSL::SPOP.respond_to? :test_deriv_phy
		describe '.test_deriv_phy' do
			it 'should return sane values' do
				[0.0, 1.0, -1.0, 10.0, -10.0].each do |f|
					RuPHY::GSL::SPOP.test_deriv_phy(0,f).should be_close(1.0, 1e-6);
				end

				[0.0, 1.0, -1.0, 10.0, -10.0].each do |f|
					RuPHY::GSL::SPOP.test_deriv_phy(1,f).should be_close(2*f, [(2*f*1e-6).abs,1e-6].max)
				end
			end
		end
	end
end

describe RuPHY::GSL::GSLError do
	if RuPHY::GSL::GSLError.respond_to? :gsl_error_test
		it 'should be raised by test method' do
			class << RuPHY::GSL::GSLError
				attr_reader :gsl_error_test_line
			end

			lambda do
				RuPHY::GSL::GSLError.gsl_error_test
			end.should raise_error RuPHY::GSL::GSLError do |ex|
				ex.reason.should == "test"
				ex.file.should   == "ruphy_gsl.c"
				ex.line.should   == RuPHY::GSL::GSLError.gsl_error_test_line
				ex.errno.should  == Errno::GSL_EINVAL
			end
		end
	end

	it 'should be raised by too large SPWF::Hydrogenic' do
		lambda do
			RuPHY::GSL::SPWF::Hydrogenic.new(1000,999,-999,500).eval(0,0,0)
		end.should raise_error RuPHY::GSL::GSLError do |ex|
			ex.reason.should == 'underflow'
			ex.errno.should == RuPHY::GSL::GSLError::Errno::GSL_UNDERFLOW
		end
	end
end
