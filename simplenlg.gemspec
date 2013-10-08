# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simplenlg/version'

Gem::Specification.new do |gem|
  gem.platform      = Gem::Platform.const_defined?(:JAVA) ? Gem::Platform::JAVA : "java"

  gem.name          = "simplenlg"
  gem.version       = SimpleNLG::VERSION
  gem.authors       = ["Thomas Efer"]
  gem.email         = ["efer@informatik.uni-leipzig.de"]
  gem.description   = %q{This JRuby gem is a wrapper for the SimpleNLG library, which is an English "realizer" used in Natural Language Generation}
  gem.summary       = %q{A JRuby wrapper for SimpleNLG}
  gem.homepage      = "https://github.com/efi/simplenlg"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
end