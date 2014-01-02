# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "legato/version"

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 1.8.7'

  s.name        = "legato"
  s.version     = Legato::VERSION
  s.authors     = ["Tony Pitale"]
  s.email       = ["tpitale@gmail.com"]
  s.homepage    = "http://github.com/tpitale/legato"
  s.summary     = %q{Access the Google Analytics API with Ruby}
  s.description = %q{Access the Google Analytics Core Reporting and Management APIs with Ruby. Create models for metrics and dimensions. Filter your data to tell you what you need.}

  s.rubyforge_project = "legato"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"
  s.add_development_dependency "bourne"
  s.add_development_dependency "vcr", "2.0.0.beta2"
  s.add_development_dependency "fakeweb"
  s.add_development_dependency "simplecov"

  s.add_runtime_dependency "multi_json"
end
