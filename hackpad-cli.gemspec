# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'hackpad-cli'
  spec.version       = File.read(File.expand_path('../CHANGELOG.md', __FILE__))[/([0-9]+\.[0-9]+\.[0-9]+)/]
  spec.authors       = ['mose']
  spec.email         = ['mose@mose.com']
  spec.summary       = %q(CLI for hackpad browsing and editing.)
  spec.description   = %q(A Command Line Interface for consuming the Hackpad REST API.)
  spec.homepage      = 'https://github.com/mose/hackpad-cli'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^spec\//)
  spec.require_paths = ['lib']

  spec.add_dependency 'thor'
  spec.add_dependency 'configstruct', '~> 0.0.3'
  spec.add_dependency 'cliprompt', '~> 0.1.0'
  spec.add_dependency 'paint'
  spec.add_dependency 'oauth'
  spec.add_dependency 'reverse_markdown'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
