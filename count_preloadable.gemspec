# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'count_preloadable/version'

Gem::Specification.new do |spec|
  spec.name          = "count_preloadable"
  spec.version       = CountPreloadable::VERSION
  spec.authors       = ["Takashi Kokubun"]
  spec.email         = ["takashikkbn@gmail.com"]
  spec.summary       = %q{N+1 count query killer for ActiveRecord}
  spec.description   = %q{count_preloadable provides a way to preload counts of ActiveRecord's associated records}
  spec.homepage      = "https://github.com/k0kubun/count_preloadable"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.2"
  spec.add_runtime_dependency "activerecord", ">= 3.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
