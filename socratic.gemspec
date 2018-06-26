$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "socratic/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "socratic"
  s.version     = Socratic::VERSION
  s.authors     = ["Gk Parish-Philp"]
  s.email       = ["gk@gkparishphilp.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Socratic."
  s.description = "TODO: Description of Socratic."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.6"

  s.add_development_dependency "sqlite3"
end
