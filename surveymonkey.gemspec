# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'surveymonkey/version'

Gem::Specification.new do |spec|
  spec.name          = "surveymonkey"
  spec.version       = Surveymonkey::VERSION
  spec.authors       = ["Steve Huff"]
  spec.email         = ["shuff@vecna.org"]

  spec.summary       = %q{Client for SurveyMonkey REST API}
  spec.description   = %q{Use rest-client to interact with SurveyMonkey's REST API.  Requires an API token.}
  spec.homepage      = "http://developer.surveymonkey.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 2.4"

  spec.add_runtime_dependency "rest-client", "~> 1.8"
  spec.add_runtime_dependency "log4r", "~> 1.1"
end
