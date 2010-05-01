require File.dirname(__FILE__) + '/spec_helper'

$:.unshift File.dirname(__FILE__) + "/../ext/gsl"
require "gsl.so"

describe "gsl" do
	it "should define module RuPHY::GSL" do
		RuPHY::GSL.should be_instance_of(Module)
	end

	it 'should define class RuPHY::GSL::SPWF' do
		RuPHY::GSL::SPWF.should be_instance_of(Class)
	end
end
