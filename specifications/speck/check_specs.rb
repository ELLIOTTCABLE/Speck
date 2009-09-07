($:.unshift File.expand_path(File.join(
  File.dirname(__FILE__), 'lib' ))).uniq!
require 'speck'

require 'speck/check'

Speck.new Speck, Speck::Check do |target|
  
  Speck.new Check.instance_method :passed? do
    object = Object.new
    
    Check.new(->{ Check.new {true} }) {|c| c.execute.passed? }
    Check.new(->{ Check.new {object} }) {|c| c.execute.passed? }
    
    Check.new(->{ Check.new {false} }) {|c|
      ! c.tap {|c| c.execute rescue nil } .passed? }
    Check.new(->{ Check.new {nil} }) {|c|
      ! c.tap {|c| c.execute rescue nil } .passed? }
  end
  
  Speck.new Check.instance_method :initialize do
    my_lambda = ->{}
    Check.new(->{ Check.new(&my_lambda) }) {|c| c.expectation == my_lambda }
    
    object = Object.new
    Check.new(->{ Check.new(my_lambda) {} }) {|c| c.target == my_lambda }
    Check.new(->{ Check.new(object) {} }) {|c| c.target.call == object }
  end
  
  Speck.new Check.instance_method :execute do
    Check.new(->{ Check.new {true} .execute }) {|c| c.passed? }
    Check.new(->{ ->{ Check.new {false} .execute } }) do |block|
      begin
        block.call
        false
      rescue Speck::Exception::CheckFailed
        true
      end
    end
    
    a_check = Check.new {true}
    Check.new(->{ a_check.execute }) {|rv| rv == a_check }
    
    object = Object.new
    Check.new(->{ Check.new(object) {|passed| @passed = passed } }) {|c|
      c.execute; @passed == object }
    
    Check.new(->{ Check.new(->{ @called = true }) {true} }) {|c|
      c.execute; @called }
  end
  
end
