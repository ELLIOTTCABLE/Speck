desc 'Runs your specks'
task :run do
  Speck::specks.select {|s| s.parent == nil }.each &:playback
end
