source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"
gem "openbabel", "~> 2.3.2.0"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "bundler", "~> 1.7"
  gem "jeweler", "~> 2.0.1"
  gem "rdoc", "~> 4.0"
  gem "racc", "~> 1.4"
  #gem "rake-compiler", "~> 0.8.0"
end

group :development, :test do
  gem "rspec", "~> 2.14.1"
end

group :test do
  gem 'rcov', "~> 1.0.0", :platform => :mri_18
  gem 'simplecov', "~> 0.8.1", :platform => :ruby_19
end

group :debug do
  gem 'debugger', :platform => :ruby_19
  gem 'byebug', :platform => [:ruby_20, :ruby_21]
end

group :profile do
  gem 'ruby-prof'
end
