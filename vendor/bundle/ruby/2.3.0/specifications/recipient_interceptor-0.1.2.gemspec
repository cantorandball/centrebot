# -*- encoding: utf-8 -*-
# stub: recipient_interceptor 0.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "recipient_interceptor"
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Dan Croak"]
  s.date = "2013-08-01"
  s.description = "    Use RecipientInterceptor when you don't want your Ruby program to\n    accidentally send emails to addresses other than those on a whitelist\n    which you configure. For example, you could use it in your web app's\n    staging environment.\n"
  s.email = "dan@thoughtbot.com"
  s.homepage = "http://github.com/croaky/recipient_interceptor"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Intercept recipients when delivering email with the Mail gem."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mail>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<mail>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<mail>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
