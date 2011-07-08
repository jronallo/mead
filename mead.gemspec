# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mead}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Ronallo"]
  s.date = %q{2011-07-08}
  s.description = %q{Extract identifiers and metadata from EAD XML.}
  s.email = %q{jronallo@gmail.com}
  s.executables = ["mead2barcode", "meadbfv", "emv", "automead", "ead2meads"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/automead",
    "bin/ead2meads",
    "bin/emv",
    "bin/mead2barcode",
    "bin/meadbfv",
    "lib/mead.rb",
    "lib/mead/barcode.rb",
    "lib/mead/container.rb",
    "lib/mead/ead.rb",
    "lib/mead/ead_validator.rb",
    "lib/mead/extractor.rb",
    "lib/mead/identifier.rb",
    "lib/mead/trollop.rb",
    "lib/mead/validations.rb",
    "mead.gemspec",
    "test/ead/mc00145.xml",
    "test/ead/mc00240.xml",
    "test/ead/ua015_010.xml",
    "test/ead/ua021_428.xml",
    "test/ead/ua023_006.xml",
    "test/ead/ua023_031.xml",
    "test/ead/ua110_041.xml",
    "test/fixtures/mc00310.xml",
    "test/fixtures/ua023_031.xml",
    "test/helper.rb",
    "test/test_barcode.rb",
    "test/test_ead.rb",
    "test/test_ead_validator.rb",
    "test/test_extractor.rb",
    "test/test_mc00145.rb",
    "test/test_mc00240.rb",
    "test/test_mead.rb",
    "test/test_ua015_010.rb",
    "test/test_ua021_428.rb",
    "test/test_ua023_006_buildings.rb",
    "test/test_ua023_006_faculty.rb",
    "test/test_ua110_041.rb",
    "test/test_validations.rb",
    "watchr.rb"
  ]
  s.homepage = %q{http://github.com/jronallo/mead}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Extract identifiers and metadata from EAD XML.}
  s.test_files = [
    "test/helper.rb",
    "test/test_barcode.rb",
    "test/test_ead.rb",
    "test/test_ead_validator.rb",
    "test/test_extractor.rb",
    "test/test_mc00145.rb",
    "test/test_mc00240.rb",
    "test/test_mead.rb",
    "test/test_ua015_010.rb",
    "test/test_ua021_428.rb",
    "test/test_ua023_006_buildings.rb",
    "test/test_ua023_006_faculty.rb",
    "test/test_ua110_041.rb",
    "test/test_validations.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.5.0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<trollop>, [">= 0"])
      s.add_runtime_dependency(%q<fastercsv>, [">= 0"])
      s.add_development_dependency(%q<rmagick>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<reek>, ["~> 1.2.8"])
      s.add_development_dependency(%q<roodi>, ["~> 2.1.0"])
      s.add_development_dependency(%q<fakeweb>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.5.0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<trollop>, [">= 0"])
      s.add_dependency(%q<fastercsv>, [">= 0"])
      s.add_dependency(%q<rmagick>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<reek>, ["~> 1.2.8"])
      s.add_dependency(%q<roodi>, ["~> 2.1.0"])
      s.add_dependency(%q<fakeweb>, [">= 0"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.5.0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<trollop>, [">= 0"])
    s.add_dependency(%q<fastercsv>, [">= 0"])
    s.add_dependency(%q<rmagick>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<reek>, ["~> 1.2.8"])
    s.add_dependency(%q<roodi>, ["~> 2.1.0"])
    s.add_dependency(%q<fakeweb>, [">= 0"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
  end
end

