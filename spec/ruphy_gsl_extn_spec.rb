require File.dirname(__FILE__) + '/spec_helper'

$:.unshift File.dirname(__FILE__) + "/../ext/ruphy_gsl"
require "ruphy_gsl.so"

describe "ruphy_gsl" do
	it "should define module RuPHY::GSL" do
		RuPHY::GSL.should be_instance_of(Module)
	end

	it 'should define class RuPHY::GSL::SPWF' do
		RuPHY::GSL::SPWF.should be_instance_of(Class)
	end

	it 'should define class RuPHY::GSL::SPWF::Hydrogenic' do
		RuPHY::GSL::SPWF::Hydrogenic.should be_instance_of(Class)
	end
end

describe RuPHY::GSL::SPWF::Hydrogenic do
	it 'should be descendant of SPWF' do
		RuPHY::GSL::SPWF::Hydrogenic.should < RuPHY::GSL::SPWF
	end
end
