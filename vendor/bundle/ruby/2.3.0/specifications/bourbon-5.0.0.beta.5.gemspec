# -*- encoding: utf-8 -*-
# stub: bourbon 5.0.0.beta.5 ruby lib

Gem::Specification.new do |s|
  s.name = "bourbon"
  s.version = "5.0.0.beta.5"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Christian Reuter", "Damian Galarza", "Gabe Berke-Williams", "Hugo Giraudel", "Joshua Ogle", "Kyle Fiedler", "Phil LaPier", "Reda Lemeden", "Tyson Gach", "Will McMahan"]
  s.date = "2016-03-23"
  s.description = "    Bourbon is a library of pure Sass mixins that are designed to be simple\n    and easy to use. No configuration required. The mixins aim to be as\n    vanilla as possible, meaning they should be as close to the original\n    CSS syntax as possible.\n"
  s.email = "design+bourbon@thoughtbot.com"
  s.executables = ["bourbon"]
  s.files = ["bin/bourbon"]
  s.homepage = "http://bourbon.io"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "A simple and lightweight mixin library for Sass"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<aruba>, ["~> 0.6.2"])
      s.add_development_dependency(%q<css_parser>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, ["~> 10.4"])
      s.add_development_dependency(%q<rspec>, ["~> 3.3"])
      s.add_development_dependency(%q<scss_lint>, ["= 0.47"])
      s.add_runtime_dependency(%q<sass>, ["~> 3.4"])
      s.add_runtime_dependency(%q<thor>, ["~> 0.19"])
    else
      s.add_dependency(%q<aruba>, ["~> 0.6.2"])
      s.add_dependency(%q<css_parser>, ["~> 1.3"])
      s.add_dependency(%q<rake>, ["~> 10.4"])
      s.add_dependency(%q<rspec>, ["~> 3.3"])
      s.add_dependency(%q<scss_lint>, ["= 0.47"])
      s.add_dependency(%q<sass>, ["~> 3.4"])
      s.add_dependency(%q<thor>, ["~> 0.19"])
    end
  else
    s.add_dependency(%q<aruba>, ["~> 0.6.2"])
    s.add_dependency(%q<css_parser>, ["~> 1.3"])
    s.add_dependency(%q<rake>, ["~> 10.4"])
    s.add_dependency(%q<rspec>, ["~> 3.3"])
    s.add_dependency(%q<scss_lint>, ["= 0.47"])
    s.add_dependency(%q<sass>, ["~> 3.4"])
    s.add_dependency(%q<thor>, ["~> 0.19"])
  end
end
