require_relative "lib/djot/version"

Gem::Specification.new do |spec|
  spec.name = "djot"
  spec.version = Djot::VERSION
  spec.authors = ["gemmaro"]
  spec.email = ["gemmaro.dev@gmail.com"]

  spec.summary = "Djot parser"
  spec.description = "djot gem provides parsing functions using original JavaScript and Lua implementations"
  spec.homepage = "https://gitlab.com/gemmaro/ruby-djot"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "execjs", "~> 2.8"
  spec.add_dependency "ruby-lua", "~> 0.4"
end
