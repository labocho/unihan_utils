# -*- encoding: utf-8 -*-
require File.expand_path('../lib/unihan_utils/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["labocho"]
  gem.email         = ["labocho@penguinlab.jp"]
  gem.description   = %q{Write a gem description}
  gem.summary       = %q{Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "unihan_utils"
  gem.require_paths = ["lib"]
  gem.version       = UnihanUtils::VERSION
  gem.add_dependency "sqlite3", "> 1.3"
  gem.add_dependency "activerecord", "> 3.0"
  gem.add_development_dependency "rspec", "~> 2.11.0"
end
