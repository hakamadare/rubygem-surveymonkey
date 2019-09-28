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
  spec.description   = %q{Interact with SurveyMonkey's REST API.  Requires an API token.}
  spec.homepage      = "https://github.com/hakamadare/rubygem-surveymonkey/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency "bundler", ">= 1.7"
  spec.add_development_dependency "dotenv", "~> 2"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rdoc", "~> 4"
  spec.add_development_dependency "rspec", "~> 2.4"
  spec.add_development_dependency "rubygems-tasks", "~> 0.2"

  spec.add_runtime_dependency "deep_merge", "~> 1"
  spec.add_runtime_dependency "httparty", "~> 0.13"
  spec.add_runtime_dependency "json", "~> 1.8"
  spec.add_runtime_dependency "logging", "~> 2"
  spec.add_runtime_dependency "timeliness", "~> 0.3"
end
