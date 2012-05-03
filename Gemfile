source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.

gem "soap4r", "~> 1.5.8", :require => 'soap/soap'

group :development do
  gem "rspec", "~> 2.8.0"
  gem "bundler", "~> 1.1.3"
  gem "jeweler", "~> 1.8.3"
  gem "rdoc", "~> 3.12"
  gem "rake-compiler", "~> 0.8.0"
end

group :autotest do
  gem "ZenTest", "~> 4.6.2"
  gem "autotest-screen", "~> 0.1.0.1"
end

group :test do
  gem "rspec", "~> 2.8.0"
  gem 'rcov', '~> 0.9.11', :platform => :ruby_18
  gem 'simplecov', '~> 0.6.1', :platform => :ruby_19
end
