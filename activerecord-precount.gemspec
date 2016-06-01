lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/precount/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-precount"
  spec.version       = ActiveRecord::Precount::VERSION
  spec.authors       = ["Takashi Kokubun"]
  spec.email         = ["takashikkbn@gmail.com"]
  spec.summary       = %q{N+1 count query killer for ActiveRecord}
  spec.description   = %q{N+1 count query killer for ActiveRecord}
  spec.homepage      = "https://github.com/k0kubun/activerecord-precount"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0"
  spec.add_runtime_dependency "activerecord", "> 4"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "erubis"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "mysql2", ">= 0.3", "< 0.4"
  spec.add_development_dependency "postgres"
  spec.add_development_dependency "dalli"
end
