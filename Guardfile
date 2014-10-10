guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^ext/(.+)/.*$})      { |m| "spec/ext/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^lib/ruphy/libint2.rb$}){ "spec/ext/ruphy_libint2_spec.rb" }

  callback(:start_begin){system 'rake compile'}
  callback(:run_on_modifications_begin){system 'rake compile'}
end
