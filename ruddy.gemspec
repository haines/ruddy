lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruddy/version"

Gem::Specification.new do |gem|
  gem.name          = "ruddy"
  gem.version       = Ruddy::VERSION
  gem.authors       = ["Andrew Haines"]
  gem.email         = ["andrew@haines.org.nz"]
  gem.summary       = %q{Basic Win32 DDE client in Ruby}
  gem.homepage      = "https://github.com/haines/ruddy"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "ffi", "~> 1.7.0"

  gem.add_development_dependency "bundler", "~> 1.3"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.13"
end
