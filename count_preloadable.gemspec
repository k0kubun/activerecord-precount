lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'count_preloadable/version'

Gem::Specification.new do |spec|
  spec.name          = "count_preloadable"
  spec.version       = CountPreloadable::VERSION
  spec.authors       = ["Takashi Kokubun"]
  spec.email         = ["takashikkbn@gmail.com"]
  spec.summary       = %q{N+1 count query killer for ActiveRecord}
  spec.description   = %q{N+1 count query killer for ActiveRecord}
  spec.homepage      = "https://github.com/k0kubun/count_preloadable"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.2"
  spec.add_runtime_dependency "activerecord", ">= 3.0"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "factory_girl", "~> 4.2.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
end
