# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ruphy"
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Katsuhiko Nishimra"]
  s.date = "2012-04-15"
  s.description = "TODO: longer description of your gem"
  s.email = "ktns.87@gmail.com"
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".autotest",
    ".document",
    ".rspec",
    "COPYING",
    "Gemfile",
    "Gemfile.lock",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/ruphy.rb",
    "lib/ruphy/basisset.rb",
    "lib/ruphy/digestable.rb",
    "lib/ruphy/geometry.rb",
    "lib/ruphy/geometry/molecule.rb",
    "lib/ruphy/theory.rb",
    "lib/ruphy/theory/rhf.rb",
    "ruphy.gemspec",
    "spec/ruphy/basisset_spec.rb",
    "spec/ruphy/geometry/molecule_spec.rb",
    "spec/ruphy/theory/rhf_spec.rb",
    "spec/ruphy_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/ktns/ruphy"
  s.licenses = ["GPLv3"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "TODO: one-line summary of your gem"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.21"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<rake-compiler>, ["~> 0.8.0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.21"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<rake-compiler>, ["~> 0.8.0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.21"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<rake-compiler>, ["~> 0.8.0"])
  end
end

