require File.dirname(__FILE__) + '/spec_helper.rb'

class RuPHY::GSL::SPWF
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
	end
end
