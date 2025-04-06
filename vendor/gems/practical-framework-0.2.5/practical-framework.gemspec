# frozen_string_literal: true

require_relative "lib/practical_framework/version"

Gem::Specification.new do |spec|
  spec.name = "practical-framework"
  spec.version = PracticalFramework::VERSION
  spec.authors = ["Thomas Cannon"]
  spec.email = ["tcannon00@gmail.com"]

  spec.summary = "The Ruby code for the Practical Framework"
  spec.description = "The Ruby code for the Practical Framework"
  spec.homepage = "https://github.com/practical-computer/practical-framework-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/practical-computer"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/practical-computer/practical-framework-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/practical-computer/practical-framework-ruby/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w(bin/ test/ spec/ features/ .git .circleci appveyor))
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rails", ">= 7.1.3.2"
  spec.add_dependency "phlex-rails"
  spec.add_dependency "loaf"
  spec.add_dependency "pagy"
  spec.add_dependency "font-awesome-helpers"
  spec.add_dependency "honeybadger"
  spec.add_dependency "semantic_logger"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
