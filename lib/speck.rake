def ansi text, code
  "\033[#{code}#{text}\033[0m"
end

def red text; ansi(text, "31m") end
def green text; ansi(text, "32m") end

desc 'Recursively runs all root specks'
task :run do
  roots = Speck::specks.select {|s| s.parent == nil }
  
  playback = lambda do |speck|
    speck.execute
    speck.checks.each do |check|
      begin
        check.execute
        # TODO: Provide more useful information about the return value and
        #       expected return value
        # TODO: Colorize negated Checks with the bang as red, or something
        #       similar
        puts check.description.ljust(72) + green(" # => " + check.status.inspect)
      rescue Speck::Exception::CheckFailed
        # TODO: Print a description of why the error failed, what was expected
        #       and what was actually received.
        puts check.description.ljust(72) + red(" # !  " + check.status.inspect)
      end
    end
    speck.children.each &playback
  end
  roots.each &playback
end
