desc 'Recursively runs all root specks'
task :run do
  roots = Speck::specks.select {|s| s.parent == nil }
  
  playback = lambda do |speck|
    speck.execute
    speck.checks.each {|c| p c.execute }
    speck.children.each &playback
  end
  roots.each &playback
end
