guard :rake, :task => 'compile', :run_on_start => true do
  watch(%r{^ext/.+})
end

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^ext/(.+)/.*$})      { |m| "spec/ext/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^lib/ruphy/libint2.rb$}){ "spec/ext/ruphy_libint2_spec.rb" }
end
