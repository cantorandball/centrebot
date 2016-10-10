# -*- encoding: utf-8 -*-
# stub: bitters 1.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "bitters"
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Kyle Fiedler", "Reda Lemeden", "Tyson Gach", "Will McMahan"]
  s.date = "2016-03-04"
  s.description = "    Bitters helps designers start projects faster by defining a basic set of\n    Sass variables, default element style and project structure. It's been\n    specifically designed for use within web applications. Bitters should live\n    in your project's root Sass directory and we encourage you to modify and\n    extend it to meet your design and brand requirements.\n"
  s.email = "design+bitters@thoughtbot.com"
  s.executables = ["bitters"]
  s.files = ["bin/bitters"]
  s.homepage = "http://bitters.bourbon.io"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Scaffold styles, variables and structure for Bourbon projects."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<scss_lint>, ["~> 0.47"])
      s.add_runtime_dependency(%q<bourbon>, [">= 5.0.0.beta.3"])
      s.add_runtime_dependency(%q<sass>, ["~> 3.4"])
      s.add_runtime_dependency(%q<thor>, ["~> 0.19"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<scss_lint>, ["~> 0.47"])
      s.add_dependency(%q<bourbon>, [">= 5.0.0.beta.3"])
      s.add_dependency(%q<sass>, ["~> 3.4"])
      s.add_dependency(%q<thor>, ["~> 0.19"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<scss_lint>, ["~> 0.47"])
    s.add_dependency(%q<bourbon>, [">= 5.0.0.beta.3"])
    s.add_dependency(%q<sass>, ["~> 3.4"])
    s.add_dependency(%q<thor>, ["~> 0.19"])
  end
end
