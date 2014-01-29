# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pagerduty/core'
require 'pagerduty/pagerduty'

Gem::Specification.new do |gem|
  gem.name          = "pagerduty-sdk"
  gem.version       = '1.0.5'
  gem.authors       = ["Alfred Moreno"]
  gem.email         = ["kryptek@gmail.com"]
  gem.description   = %q{An SDK for Pagerduty's API}
  gem.summary       = %q{An SDK for communication with the entire Pagerduty API}
  gem.homepage      = "https://github.com/kryptek/pagerduty-sdk"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activesupport'
  gem.add_dependency 'json'
  gem.add_dependency 'virtus'

  gem.license       = 'MIT'
end
