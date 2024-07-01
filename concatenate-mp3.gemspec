# frozen_string_literal: true

require_relative "lib/concatenate/mp3/version"

Gem::Specification.new do |spec|
  spec.name = "concatenate-mp3"
  spec.version = Concatenate::Mp3::VERSION
  spec.authors = ["DevCurumin"]
  spec.email = ["thiago.chirana@gmail.com"]

  spec.summary = "Just only a gem that concatenate two or more Mp3 files"
  spec.description = "concatenate-mp3 is a gem ruby that allows you to concatenate two or more .mp3 files into one"
  spec.homepage = "https://github.com/thiagochirana/concatenate-mp3"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "colorize", "~> 0.8.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
