require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'Default: Run all specs'
task :default => :spec

desc 'Run all specs'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['--color']
end
