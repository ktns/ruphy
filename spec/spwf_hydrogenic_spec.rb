require File.dirname(__FILE__) + '/spec_helper.rb'

module RuPHY::GSL
	module SPWF
		class Hydrogenic
			describe InvalidQuantumNumbersError do
				describe '.check' do
					it 'should raise error if quantum number is invalid' do
						[[0,0,0],[-1,0,0],[1,-1,0],[1,1,0],[1,0,1],[1,0,-1]].each do |n,l,m|
							lambda do
								InvalidQuantumNumbersError.check n,l,m
							end.should raise_error InvalidQuantumNumbersError
						end
						[[1.1,0,0],[1,'a',0],[1,0,[1]]].each do |n,l,m|
							lambda do
								InvalidQuantumNumbersError.check n,l,m
							end.should raise_error TypeError
						end
					end

					it 'should not raise error if quantum number is valid' do
						[[1,0,0],[2,0,0],[2,1,1],[2,1,-1]].each do |n,l,m|
							lambda do
								InvalidQuantumNumbersError.check n,l,m
							end.should_not raise_error
						end
					end
				end
			end

			describe InvalidAtomicNumberError do
				describe '.check' do
					it 'should raise error if atomic number is invalid' do
						[0,-1].each do |z|
							lambda do
								InvalidAtomicNumberError.check z
							end.should raise_error InvalidAtomicNumberError
						end
						[1.1,'1',[1]].each do |z|
							lambda do
								InvalidAtomicNumberError.check z
							end.should raise_error TypeError
						end
					end

					it 'should not raise error if atomic number is valid' do
						(1..18).each do |z|
							lambda do
								InvalidAtomicNumberError.check z
							end.should_not raise_error
						end
					end
				end
			end

			describe Hydrogenic do
				it 'should respond to :new' do
					Hydrogenic.should respond_to :new
				end

				describe '#initialize' do
					it 'should invoke argument validation' do
						InvalidQuantumNumbersError.should_receive(:check).with(:n,:l,:p)
						InvalidAtomicNumberError.should_receive(:check).with(:Z)
						Hydrogenic.new(:n, :l, :p, :Z)
					end
				end

				describe '#eval' do
					before :all do
						@s1 = Hydrogenic.new(1,0,0)
					end

					it 'should return complex number' do
						@s1.should respond_to(:eval)
						@s1.eval(0,0,0).should be_kind_of(Complex)
					end

					describe 'on different Z' do
						before :all do
							@Z = 1 + rand(100)
							@s2 = Hydrogenic.new(1,0,0,@Z)
						end

						it 'should return propotional value at (r/Z)' do
							ratio = @s1.eval(0,0,0) / @s2.eval(0,0,0)
							@s1.should_be_equivalent do |r, theta, phy|
								@s2.eval(r/@s2.Z, theta, phy) * ratio
							end
						end
					end
				end

				random_spwf_hydrogenic_subset(3).each do |phy|
					describe phy do
						it 'should be normalized', :phy => phy do
							(options[:phy] * options[:phy]).should be_close 1, 1e-5
						end
					end
				end

				random_spwf_hydrogenic_subset(3).combination(2) do |phy1, phy2|
					describe "#{phy1} and #{phy2}" do
						it 'should be mutually orthogonal', :phy1 => phy1, :phy2 => phy2 do
							(options[:phy1] * options[:phy2]).should be_close 0, 1e-5
						end
					end
				end
			end
		end
	end
end
