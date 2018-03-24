$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "date_picker/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "date_picker"
  s.version     = DatePicker::VERSION
  s.authors     = ["Rafael Nowrotek"]
  s.email       = ["mail@benignware.com"]
  s.homepage    = "https://github.com/benignware/date_picker"
  s.summary     = "Rails DatePicker-Integration"
  s.description = "Rails DatePicker-Integration"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 5.1.0"

end
