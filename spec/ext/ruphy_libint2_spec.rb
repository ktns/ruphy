require 'ruphy_libint2'

describe RuPHY::Libint2 do
  if described_class.compiled?
    #TODO: tests here
  else
    $stderr.puts "Libint2 extension is not compiled"
  end
end
