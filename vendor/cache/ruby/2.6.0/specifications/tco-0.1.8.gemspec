# -*- encoding: utf-8 -*-
# stub: tco 0.1.8 ruby lib

Gem::Specification.new do |s|
  s.name = "tco".freeze
  s.version = "0.1.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Radek Pazdera".freeze]
  s.date = "2015-07-04"
  s.description = "tco is a commandline tool and also a Ruby module that\n                     allows its users to easily colourize the terminal\n                     output of their bash scripts as well as Ruby programs.".freeze
  s.email = ["radek@pazdera.co.uk".freeze]
  s.executables = ["tco".freeze]
  s.files = ["bin/tco".freeze]
  s.homepage = "https://github.com/pazdera/tco".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "A tool and a library for terminal output colouring".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.5"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.5"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.5"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end
