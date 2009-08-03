($:.unshift File.expand_path(File.join( File.dirname(__FILE__), 'lib' ))).uniq!
require 'speck'

namespace :speck do
  load 'speck.rake'
end
