require_relative './config/environment'
require "bundler/gem_tasks"
task :default => :spec

def reload!
  load_all './lib'
end

task :console do
  Pry.start
end
