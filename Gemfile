source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"
gem "openbabel", "~> 2.3.1.8"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "rspec", "~> 2.12.0"
  gem "bundler", "~> 1.2.2"
  gem "jeweler", "~> 1.8.3"
  gem "rdoc", "~> 3.12"
  #gem "rake-compiler", "~> 0.8.0"
end

group :test do
  gem "rspec", "~> 2.12.0"
  gem 'rcov', '~> 1.0.0', :platform => :mri_18
  gem 'simplecov', '~> 0.7.1', :platform => :ruby_19
end

group :debug do
  gem 'ruby-debug', :platform => :ruby_18
  gem 'ruby-debug19', :platform => :ruby_19
end
