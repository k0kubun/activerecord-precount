require "bundler/gem_tasks"
require "rake/testtask"

desc 'Run count_loader benchmarks'
task :benchmark do
  ruby('benchmark.rb')
end

Rake::TestTask.new do |t|
  t.libs << "lib" << "test"
  t.test_files = Dir.glob("test/**/*_test.rb")
end

task default: :test
