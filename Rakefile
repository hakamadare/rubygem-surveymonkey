require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubygems/tasks"

# Default directory to look in is `/specs`
# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'documentation']
end

task :default => :spec

# RubyGems tasks
Gem::Tasks.new do |tasks|
  tasks.console.command = "pry"
end
