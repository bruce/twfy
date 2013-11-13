# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twfy/version'

Gem::Specification.new do |spec|
  spec.name          = "twfy"
  spec.version       = Twfy::VERSION
  spec.authors       = ["Tom Hipkin", "Martin Owen", "Bruce Williams"]
  spec.email         = ["brwcodes@gmail.com", "tomhipkin@gmail.com"]
  spec.description   = "Ruby library to interface with the TheyWorkForYou API."
  spec.summary       = "Ruby library to interface with the TheyWorkForYou API. TheyWorkForYou.com is a non-partisan, volunteer-run website which aims to make it easy for people to keep tabs on their elected and unelected representatives in Parliament."
  spec.homepage      = "http://github.com/bruce/twfy"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "multi_json"
  spec.add_dependency "paginator", "~> 1.2"
  spec.add_development_dependency "bundler", "~> 1.3.5"
  spec.add_development_dependency "json"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

end
