$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "siringa/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "siringa"
  s.version     = Siringa::VERSION
  s.authors     = ["Enrico Stano"]
  s.email       = ["enricostn@gmail.com"]
  s.homepage    = "https://github.com/enricostano/siringa"
  s.summary     = "Remotely populate DB for Rails applications for pure client acceptance testing"
  s.description = "Remotely populate DB for Rails applications for pure client acceptance testing"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "sqlite3"
end
