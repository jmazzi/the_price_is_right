# -*- encoding: utf-8 -*-
require File.expand_path('../lib/the_price_is_right/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Justin Mazzi"]
  gem.email         = ["jmazzi@gmail.com"]
  gem.description   = %q{It does stuff; it doesn't have tests; IT'S PROBABLY DANGEROUS TO USE.}
  gem.summary       = %q{It does stuff; it doesn't have tests; IT'S PROBABLY DANGEROUS TO USE.}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "the_price_is_right"
  gem.require_paths = ["lib"]
  gem.version       = ThePriceIsRight::VERSION

  gem.add_dependency 'github_api', '~> 0.4.2'
  gem.add_dependency 'retryable-rb', '~> 1.1.0'
  gem.add_dependency 'awesome_print', '~> 1.0.2'
  gem.add_dependency 'terminal-table', '~> 1.4.4'

  gem.add_development_dependency 'rake', '~> 0.9.2.2'
end
