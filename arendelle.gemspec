# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arendelle'

Gem::Specification.new do |spec|
  spec.name          = "arendelle"
  spec.version       = Arendelle::VERSION
  spec.authors       = ["Rob Cole"]
  spec.email         = ["robcole@useed.org"]

  spec.summary       = %q{A simple gem for creating mostly frozen objects.
                          Useful for configuration-like objects.}
  spec.homepage      = "https://github.com/useed/arendelle"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/}) || f.match(%r{\.gem})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
