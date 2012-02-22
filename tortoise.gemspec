# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tortoise/version"

Gem::Specification.new do |s|
  s.name        = "tortoise"
  s.version     = Tortoise::VERSION
  s.authors     = ["Chris Hunt"]
  s.email       = ["huntca@gmail.com"]
  s.homepage    = "https://github.com/huntca/tortoise"
  s.summary     = %q{Tortoise is a Logo interpreter for ruby.}
  s.description = %q{Tortoise is a Logo interpreter for ruby.}

  s.rubyforge_project = "tortoise"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_runtime_dependency "rest-client"

  s.add_development_dependency "rspec"
end
