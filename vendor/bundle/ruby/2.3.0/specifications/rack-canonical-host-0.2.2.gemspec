# -*- encoding: utf-8 -*-
# stub: rack-canonical-host 0.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "rack-canonical-host"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tyler Hunt"]
  s.date = "2016-05-17"
  s.homepage = "http://github.com/tylerhunt/rack-canonical-host"
  s.rubygems_version = "2.5.1"
  s.summary = "Rack middleware for defining a canonical host name."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<addressable>, ["< 3", "> 0"])
      s.add_runtime_dependency(%q<rack>, ["< 3", ">= 1.0.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
    else
      s.add_dependency(%q<addressable>, ["< 3", "> 0"])
      s.add_dependency(%q<rack>, ["< 3", ">= 1.0.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<addressable>, ["< 3", "> 0"])
    s.add_dependency(%q<rack>, ["< 3", ">= 1.0.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
  end
end
