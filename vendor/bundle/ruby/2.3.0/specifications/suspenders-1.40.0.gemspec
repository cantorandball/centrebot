# -*- encoding: utf-8 -*-
# stub: suspenders 1.40.0 ruby lib

Gem::Specification.new do |s|
  s.name = "suspenders"
  s.version = "1.40.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["thoughtbot"]
  s.date = "2016-06-25"
  s.description = "Suspenders is a base Rails project that you can upgrade. It is used by\nthoughtbot to get a jump start on a working app. Use Suspenders if you're in a\nrush to build something amazing; don't use it if you like missing deadlines.\n"
  s.email = "support@thoughtbot.com"
  s.executables = ["suspenders"]
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = ["LICENSE", "README.md", "bin/suspenders"]
  s.homepage = "http://github.com/thoughtbot/suspenders"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.1")
  s.rubygems_version = "2.5.1"
  s.summary = "Generate a Rails app using thoughtbot's best practices."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bitters>, ["~> 1.3"])
      s.add_runtime_dependency(%q<bundler>, ["~> 1.3"])
      s.add_runtime_dependency(%q<rails>, ["~> 4.2.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.2"])
    else
      s.add_dependency(%q<bitters>, ["~> 1.3"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rails>, ["~> 4.2.0"])
      s.add_dependency(%q<rspec>, ["~> 3.2"])
    end
  else
    s.add_dependency(%q<bitters>, ["~> 1.3"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rails>, ["~> 4.2.0"])
    s.add_dependency(%q<rspec>, ["~> 3.2"])
  end
end
