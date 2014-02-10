$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "audited-activerecord-reporting/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "audited-activerecord-reporting"
  s.version     = AuditedActiverecordReporting::VERSION
  s.authors     = ["Valentino", "Nicholas Hance"]
  s.email       = ["valentino@reenhanced.com"]
  s.description = %q{A reporting and visualization tool for the audited gem}
  s.summary     = %q{A reporting and visualization tool for the audited gem}
  s.homepage    = "https://github.com/reenhanced/audited-activerecord-reporting"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.16"
  s.add_dependency "audited-activerecord", "~> 3.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
end
