# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mead"
  s.version = "0.1.3"
  s.authors = ["Jason Ronallo"]
  s.email = "jronallo@gmail.com"
  s.homepage = "http://github.com/jronallo/mead"
  s.summary = "Extract identifiers and metadata from EAD XML."
  s.description = "Extract identifiers and metadata from EAD XML."
  s.rubyforge_project = "mead"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]  
  s.licenses = ["MIT"]
  

  s.add_runtime_dependency(%q<nokogiri>, ["~> 1.5.0"])
  s.add_runtime_dependency(%q<json>, [">= 0"])
  s.add_runtime_dependency(%q<trollop>, [">= 0"])
  
  # s.add_development_dependency(%q<rmagick>, [">= 0"])
  s.add_development_dependency(%q<shoulda>, [">= 0"])
  s.add_development_dependency(%q<fakeweb>, [">= 0"])  
end

