# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gas-blender/version'

Gem::Specification.new do |spec|
  spec.name          = "gas-blender"
  spec.version       = GasBlender::VERSION
  spec.authors       = ["Ken Mayer"]
  spec.email         = ["ken@bitwrangler.com"]
  spec.summary       = %q{Gas blending tools for SCUBA divers}
  spec.description   = %q{Gas blending tools for SCUBA divers. A thought experiment.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
