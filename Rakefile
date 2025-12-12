# frozen_string_literal: true

Rake.add_rakelib "tasks"
Rake.add_rakelib "tasks/**"

require_relative "tasks/utils"

require "bundler/gem_tasks"
require "rdoc/task"
require "standard/rake"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

RDoc::Task.new do |rdoc|
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README.md", "lib/**/*.rb")
  rdoc.rdoc_dir = "doc"
end

task default: %i[spec standard]
