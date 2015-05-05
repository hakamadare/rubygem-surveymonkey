require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubygems/tasks"
require "rdoc/task"

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

# RDoc tasks
RDoc::Task.new do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include("README.md", "lib/*/*.rb", "lib/*/*/*.rb", "lib/*/*/*/*.rb")
end
