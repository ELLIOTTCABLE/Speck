# -*- encoding: utf-8 -*-
($:.unshift File.expand_path(File.join( File.dirname(__FILE__), 'lib' ))).uniq!

Gem::Specification.new do |gem|
   gem.name = 'speck'; require gem.name
   gem.version = Speck::VERSION
   gem.homepage = "http://github.com/elliottcable/speck"
   
   gem.author = "elliottcable [http://ell.io/tt]"
   gem.license = 'MIT'
   
   gem.summary = <<-SUMMARY.delete("\n").squeeze(' ').strip
      An (extremely light) source-code literate code-specification and -testing system.
      (see: spark, slack)
   SUMMARY
   
   gem.files = Dir['lib/**/*'] + %w[README.markdown LICENSE.text] & `git ls-files -z`.split("\0")
end
