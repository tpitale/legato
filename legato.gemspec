# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "legato/version"

Gem::Specification.new do |s|
  s.name        = "legato"
  s.version     = Legato::VERSION
  s.authors     = ["Tony Pitale"]
  s.email       = ["tpitale@gmail.com"]
  s.homepage    = "" # "http://legato.github.com"
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "legato" # ?

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"
  s.add_development_dependency "bourne"
  # s.add_development_dependency "vcr"

  s.add_runtime_dependency "oauth2"
end
