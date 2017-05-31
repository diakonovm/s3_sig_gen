# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "s3_sig_gen/version"

Gem::Specification.new do |spec|
  spec.name          = "s3_sig_gen"
  spec.version       = S3SigGen::VERSION
  spec.authors       = ["Michael Diakonov"]
  spec.email         = ["diakonov.m@gmail.com"]
  spec.homepage      = ""
  spec.summary       = %q{}
  spec.description   = %q{}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

end
