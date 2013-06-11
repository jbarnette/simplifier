Gem::Specification.new do |gem|
  gem.name          = "simplifier"
  gem.version       = "0.0.0"
  gem.authors       = ["John Barnette"]
  gem.email         = ["john@jbarnette.com"]
  gem.description   = "Reduce objects to a simpler representation."
  gem.summary       = "Reduce object graphs."
  gem.homepage      = "https://github.com/jbarnette/simplifier"

  gem.files         = `git ls-files`.split $/
  gem.executables   = []
  gem.test_files    = gem.files.grep /^test/
  gem.require_paths = ["lib"]

  gem.add_development_dependency "minitest"
end
