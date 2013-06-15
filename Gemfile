source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"
gem "openbabel", "~> 2.3.1.8"
gem "backports", "~> 2.6.5"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "rspec", "~> 2.13.0"
  gem "rspec-expectations", :github => 'ktns/rspec-expectations', :branch => 'fix-2.13'
  gem "bundler", "~> 1.3.5"
  gem "jeweler", "~> 1.8.4"
  gem "rdoc", "~> 4.0"
  gem "racc", "~> 1.4"
  #gem "rake-compiler", "~> 0.8.0"
end

group :test do
  gem "rspec", "~> 2.13.0"
  gem "rspec-expectations", :github => 'ktns/rspec-expectations', :branch => 'fix-2.13'
  gem 'rcov', "~> 1.0.0", :platform => :mri_18
  gem 'simplecov', "~> 0.7.1", :platform => :ruby_19
end

group :debug do
  gem 'ruby-debug', :platform => :ruby_18
  gem 'ruby-debug19', :platform => :ruby_19
end

group :autotest do
  gem 'ZenTest'
end

group :autotest_inotify do
  gem 'autotest-inotify'
end

group :autotest_tmux do
  gem 'autotest-tmux'
end

if RUBY_PLATFORM =~ /darwin/
  group :autotest_fsevents do
    gem 'autotest-fsevents'
  end
end

group :autotest_growl do
  gem 'autotest-growl'
end
