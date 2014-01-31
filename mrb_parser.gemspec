# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mrb_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "mrb_parser"
  spec.version       = MrbParser::VERSION
  spec.authors       = ["yamanekko"]
  spec.email         = ["yamanekko@tatsu-zine.com"]
  spec.description   = %q{simple library to parse mrb file, mruby bytecode file.}
  spec.summary       = %q{mrb (mruby bytecode) parser}
  spec.homepage      = "https://github.com/yamanekko/mrb_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
