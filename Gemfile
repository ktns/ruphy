source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"
gem "openbabel", "~> 2.3.2.0"
gem "backports", "~> 2.6.5"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "bundler", ">= 1.3.5"
  gem "rspec", "~> 2.14.1"
  gem "jeweler", "~> 2.0.1"
  gem "rdoc", "~> 4.0"
  gem "racc", "~> 1.4"
  #gem "rake-compiler", "~> 0.8.0"
end

group :test do
  gem "rspec", "~> 2.14.1"
  gem 'rcov', "~> 1.0.0", :platform => :mri_18
  gem 'simplecov', "~> 0.8.1", :platform => :ruby_19
end

group :debug do
  gem 'ruby-debug', :platform => :ruby_18
  gem 'ruby-debug19', :platform => :ruby_19
end

group :autotest do
  gem 'ZenTest'
end

group :profile do
  gem 'ruby-prof'
end

group :autotest_inotify do
  gem 'autotest-inotify'
end

group :autotest_tmux do
  gem 'autotest-tmux'
end

group :autotest_fsevent do
  gem 'autotest-fsevent', :require => (RUBY_PLATFORM =~ /darwin/)
end

group :autotest_growl do
  gem 'autotest-growl'
end
