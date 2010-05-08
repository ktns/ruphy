require File.dirname(__FILE__) + '/spec_helper.rb'

module RuPHY::GSL::SPWF
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
			describe '#initialize' do
				it 'should invoke argument validation' do
					InvalidQuantumNumbersError.should_receive(:check).with(:n,:l,:p)
					InvalidAtomicNumberError.should_receive(:check).with(:Z)
					Hydrogenic.new(:n, :l, :p, :Z)
				end
			end

			describe '#eval' do
				before do
					@s1 = Hydrogenic.new(1,0,0)
				end

				it 'should be defined' do
					@s1.should respond_to(:eval)
					@s1.eval(0,0,0).should be_kind_of(Complex)
				end
			end
		end
	end
end
