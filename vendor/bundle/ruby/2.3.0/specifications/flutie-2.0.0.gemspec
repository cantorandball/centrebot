# -*- encoding: utf-8 -*-
# stub: flutie 2.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "flutie"
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Matt Jankowski", "Chad Pytel", "Kevin Burg", "Chad Mazzola", "Phil LaPier", "Dan Croak", "Fred Yates", "OZAWA Sakuro", "Mike Burns", "Greg Sterndale", "Joe Ferris", "J. Edward Dewyea", "Emilien Taque", "Aaron Suggs", "Nick Quaranto"]
  s.date = "2013-02-12"
  s.description = "Flutie is a starting point for personal discovery"
  s.email = ["support@thoughtbot.com"]
  s.homepage = "http://github.com/thoughtbot/flutie"
  s.rubygems_version = "2.5.1"
  s.summary = "Flutie provides extra Rails view helpers"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<appraisal>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
    else
      s.add_dependency(%q<appraisal>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
    end
  else
    s.add_dependency(%q<appraisal>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
  end
end
