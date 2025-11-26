# frozen_string_literal: true

require_relative "lib/detektor/version"

Gem::Specification.new do |spec|
  spec.name = "detektor"
  spec.version = Detektor::VERSION
  spec.authors = ["Phoenix Rodden"]
  spec.email = ["phoenix.rodden@agilebits.com"]

  spec.summary = "TODO: Write a short summary, because RubyGems requires one."
  spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.required_ruby_version = ">= 3.1.0"

  spec.files = Dir["lib/**/*", "README.md", "detektor.gemspec"]
  spec.require_paths = ["lib"]
end
