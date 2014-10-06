$:.push(File.expand_path('../lib', __FILE__))
require 'poiful/version'

Gem::Specification.new do |gem|
  gem.name = 'poiful'
  gem.version = Poiful::VERSION
  gem.platform = Gem::Platform::RUBY
  gem.authors = ["Fumihiro Ito"]
  gem.email = ["fmhrit at gmail com"]
  gem.homepage = 'http://github.com/f110/poiful'
  gem.description = %Q{Profiler for Ruby 1.9+}
  gem.summary = gem.description
  gem.license = "MIT"

  gem.add_dependency 'rblineprof', '~> 0.3.6'

  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- spec/*`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map {|f| File..basename(f)}
  gem.require_paths = ["lib"]
end
