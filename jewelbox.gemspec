# -*- encoding: utf-8 -*-
require File.expand_path('../lib/jewelbox/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Steve Jang"]
  gem.email         = ["estebanjang@gmail.com"]
  gem.description   = %q{A set of useful Ruby functions to be used when creating a new service or rails application}
  gem.summary       = %q{Contains functions that support service configuration, useful ruby methods (such as eigenclass), and other functionality commonly used by Ruby services}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "jewelbox"
  gem.require_paths = ["lib"]
  gem.version       = Jewelbox::VERSION

  gem.add_development_dependency('ruby-debug19')
end
