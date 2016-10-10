# -*- encoding: utf-8 -*-
# stub: nexmo 4.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "nexmo"
  s.version = "4.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tim Craft"]
  s.date = "2016-06-30"
  s.description = "Nexmo Client Library for Ruby"
  s.email = ["mail@timcraft.com"]
  s.homepage = "https://github.com/Nexmo/nexmo-ruby"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.5.1"
  s.summary = "This is the Ruby client library for Nexmo's API. To use it you'll need a Nexmo account. Sign up for free at https://www.nexmo.com"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_development_dependency(%q<webmock>, ["~> 1.18"])
      s.add_development_dependency(%q<minitest>, ["~> 5.0"])
    else
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<webmock>, ["~> 1.18"])
      s.add_dependency(%q<minitest>, ["~> 5.0"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<webmock>, ["~> 1.18"])
    s.add_dependency(%q<minitest>, ["~> 5.0"])
  end
end
