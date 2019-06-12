# -*- encoding: utf-8 -*-
# stub: catpix 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "catpix".freeze
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Radek Pazdera".freeze]
  s.date = "2015-07-04"
  s.description = "Print images (png, jpg, gif and many others) in the\n                          command line with ease. Using rmagick and tco in the\n                          background to read the images and convert them into\n                          the extended 256 colour palette for terminals.".freeze
  s.email = ["me@radek.io".freeze]
  s.executables = ["catpix".freeze]
  s.files = ["bin/catpix".freeze]
  s.homepage = "https://github.com/pazdera/catpix".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Cat images into the terminal.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<tco>.freeze, ["~> 0.1", ">= 0.1.8"])
      s.add_runtime_dependency(%q<rmagick>.freeze, ["~> 2.15", ">= 2.15.2"])
      s.add_runtime_dependency(%q<docopt>.freeze, ["~> 0.5", ">= 0.5.0"])
      s.add_runtime_dependency(%q<ruby-terminfo>.freeze, ["~> 0.1", ">= 0.1.1"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.6"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.4"])
    else
      s.add_dependency(%q<tco>.freeze, ["~> 0.1", ">= 0.1.8"])
      s.add_dependency(%q<rmagick>.freeze, ["~> 2.15", ">= 2.15.2"])
      s.add_dependency(%q<docopt>.freeze, ["~> 0.5", ">= 0.5.0"])
      s.add_dependency(%q<ruby-terminfo>.freeze, ["~> 0.1", ">= 0.1.1"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.6"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.4"])
    end
  else
    s.add_dependency(%q<tco>.freeze, ["~> 0.1", ">= 0.1.8"])
    s.add_dependency(%q<rmagick>.freeze, ["~> 2.15", ">= 2.15.2"])
    s.add_dependency(%q<docopt>.freeze, ["~> 0.5", ">= 0.5.0"])
    s.add_dependency(%q<ruby-terminfo>.freeze, ["~> 0.1", ">= 0.1.1"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.6"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.4"])
  end
end
