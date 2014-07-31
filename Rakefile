require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "--tty"
end

desc 'Run spinach features'
task :spinach do
  exec "bin/spinach"
end

task :default => [:spec, :spinach]