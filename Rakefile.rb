($:.unshift File.expand_path(File.join( File.dirname(__FILE__), 'lib' ))).uniq!
require 'speck'

# ===============
# = Speck tasks =
# ===============
begin
  task :default => :'speck:run'
  
  task :speck => :'speck:run'
  namespace :speck do
    task :run do
      Dir['./specifications/**/*_specs.rb'].each {|f| require f }
      
      playback = lambda do |speck|
        p speck.target
        speck.execute
        speck.checks.each &:execute
        speck.children.each &playback
      end
      
      Speck::unbound.each &playback
    end
  end
end

# =======================
# = Documentation tasks =
# =======================
begin
  require 'yard'
  require 'yard/rake/yardoc_task'
  
  task :documentation => :'documentation:generate'
  namespace :documentation do
    YARD::Rake::YardocTask.new :generate do |t|
      t.files   = ['lib/**/*.rb']
      t.options = ['--output-dir', File.join('meta', 'documentation'),
                   '--readme', 'README.markdown',
                   '--markup', 'markdown', '--markup-provider', 'maruku']
    end
    
    task :open do
      system 'open ' + File.join('meta', 'documentation', 'index.html') if RUBY_PLATFORM['darwin']
    end
  end
  
rescue LoadError
  desc 'You need the `yard` and `maruku` gems to generate documentation'
  task :documentation
end


namespace :package do
  task :package do; system "gem build " + Dir['*.gemspec'].first; end
  task :install => :package do; system "gem install " + Dir['*.gem'].first; end
end

desc 'Check everything over before commiting'
task :aok => [:'documentation:generate', :'documentation:open',
              :'package:package',
              :'speck:run']

task :ci => [:'documentation:generate', :'speck:run']
