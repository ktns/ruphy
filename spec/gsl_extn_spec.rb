require File.dirname(__FILE__) + '/spec_helper'

$:.unshift File.dirname(__FILE__) + "/../ext/gsl"
require "gsl.so"

describe "gsl" do
	it "should do nothing" do
		true.should == true
	end
	end
