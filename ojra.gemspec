# frozen_string_literal: true

require_relative "lib/ojra/version"

Gem::Specification.new do |spec|
  spec.name = "ojra"
  spec.version = OJRA::VERSION
  spec.authors = ["Juanjo Bazán"]
  spec.email = ["jjbazan@gmail.com"]
  spec.platform = Gem::Platform::RUBY
  spec.date = Time.now.strftime('%Y-%m-%d')

  spec.summary = "Wrapper for the Open Journal's Reviewers API "
  spec.description = "Ruby wrapper for the Open Journal's Reviewers application's API"
  spec.homepage = "http://github.com/xuanxu/ojra"
  spec.required_ruby_version = ">= 2.7.7"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["bug_tracker_uri"] = "https://github.com/xuanxu/ojra/issues"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.7"

  spec.add_development_dependency "rake", "~> 13.0.6"
  spec.add_development_dependency "rspec", "~> 3.12"
end
