lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rspec_overview/version"

Gem::Specification.new do |spec|
  spec.name          = "rspec_overview"
  spec.version       = RspecOverview::VERSION
  spec.authors       = ["Oli Peate"]
  spec.license       = "MIT"

  spec.summary       = "See an overview of your RSpec test suite"
  spec.homepage      = "https://github.com/odlp/rspec_overview"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec-core", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "pry-byebug", "~> 3.5"
  spec.add_development_dependency "rake", ">= 12"
  spec.add_development_dependency "rspec", "~> 3.7"
end
