require File.dirname(__FILE__) + '/spec_helper'

$:.unshift File.dirname(__FILE__) + "/../ext/gsl"
require "gsl.so"

describe "gsl" do
	it "should define module RuPHY::GSL" do
		RuPHY::GSL.should be_instance_of(Module)
	end
end
