($:.unshift File.expand_path(File.join(
  File.dirname(__FILE__)                ))).uniq!
($:.unshift File.expand_path(File.join(
  File.dirname(__FILE__), '..', 'lib'   ))).uniq!

begin
  require 'speck'
  require 'smock'
rescue LoadError
  puts "Speck itself requires Smock to run its specifications:"
  puts
  puts "    gem install smock"
  exit 1
end
