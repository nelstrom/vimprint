# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "vimprint/version"

Gem::Specification.new do |s|
  s.name        = "vimprint"
  s.version     = Vimprint::VERSION
  s.authors     = ["Drew Neil"]
  s.email       = ["andrew.jr.neil@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Parse Vim keystrokes, pretty print them.}
  s.description = %q{vimprint takes a stream of Vim keystrokes as input, and transforms them into something more easy on the eye. }

  s.rubyforge_project = "vimprint"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here:
  s.add_development_dependency "rake"
  s.add_runtime_dependency "nokogiri", "~> 1.5"
end
