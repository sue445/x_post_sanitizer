# frozen_string_literal: true

require_relative "lib/x_post_sanitizer/version"

Gem::Specification.new do |spec|
  spec.name = "x_post_sanitizer"
  spec.version = XPostSanitizer::VERSION
  spec.authors = ["sue445"]
  spec.email = ["sue445@sue445.net"]

  spec.summary = "Sanitize X Post (formerly Twitter Tweet)"
  spec.description = "Sanitize X Post (formerly Twitter Tweet)"
  spec.homepage = "https://github.com/sue445/x_post_sanitizer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://sue445.github.io/x_post_sanitizer/"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "irb"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rbs"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-parameterized"
  spec.add_development_dependency "steep"
  spec.add_development_dependency "yard"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
