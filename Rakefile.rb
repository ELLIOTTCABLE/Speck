($:.unshift File.expand_path(File.join( File.dirname(__FILE__), 'lib' ))).uniq!
require 'speck'

# =======================
# = Gem packaging tasks =
# =======================
begin
  require 'echoe'
  
  task :install => :'package:install'
  task :package => :'package:package'
  task :manifest => :'package:manifest'
  namespace :package do
    Echoe.new('speck', Speck::Version) do |g|
      g.project = 'speck'
      g.author = ['elliottcable']
      g.email = ['Speck@elliottcable.com']
      g.summary = "Supah-light 'n sexy specking!"
      g.url = 'http://github.com/elliottcable/speck'
      g.runtime_dependencies = []
      g.development_dependencies = ['echoe >= 3.0.2']
      g.manifest_name = '.manifest'
      g.retain_gemspec = true
      g.rakefile_name = 'Rakefile.rb'
      g.ignore_pattern = /^\.git\/|\.gemspec/
    end
  end
  
rescue LoadError
  desc 'You need the `echoe` gem to package Speck'
  task :package
end

# ===============
# = Speck tasks =
# ===============
begin
  # require 'speck'
  
  task :default => :'speck:run'
  task :speck => :'speck:run'
  namespace :speck do
    load 'speck.rake'
  end
  
rescue LoadError
  desc 'You need the `speck` gem to run specks'
  task :speck
end
