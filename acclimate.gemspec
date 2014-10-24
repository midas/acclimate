# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acclimate/version'

Gem::Specification.new do |spec|
  spec.name          = "acclimate"
  spec.version       = Acclimate::VERSION
  spec.authors       = ["C. Jason Harrelson (midas )"]
  spec.email         = ["jason@lookforwardenterprises.com"]
  spec.summary       = %q{A Cli building toolkit.}
  spec.description   = %q{A Cli building toolkit.  See README for more details.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "gem-dandy"
  spec.add_development_dependency "pry-debugger"
  spec.add_development_dependency "rake"

  spec.add_dependency "hashie"
  spec.add_dependency "rainbow"
  spec.add_dependency "thor"
end
