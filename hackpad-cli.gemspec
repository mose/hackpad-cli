# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hackpad/cli/version'

Gem::Specification.new do |spec|
  spec.name          = "hackpad-cli"
  spec.version       = Hackpad::Cli::VERSION
  spec.authors       = ["mose"]
  spec.email         = ["mose@mose.com"]
  spec.summary       = %q{CLI for hackpad browsing and editing.}
  spec.description   = %q{A Command Line Interface for consuming the Hackpad REST API.}
  spec.homepage      = "https://github.com/mose/hackpad-cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "colorize"
  spec.add_dependency "oauth"
  spec.add_dependency "reverse_markdown"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
