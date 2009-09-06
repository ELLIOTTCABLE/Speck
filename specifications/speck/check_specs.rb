($:.unshift File.expand_path(File.join(
  File.dirname(__FILE__), 'lib' ))).uniq!
require 'speck'

require 'speck/check'

Speck.new Speck::Check do |target|
  Check = Speck::Check
  
  Speck.new Check.instance_method :pass? do
    object = Object.new
    
    Check.new(->{ Check.new {true} }) {|c| c.execute.pass? }
    Check.new(->{ Check.new {object} }) {|c| c.execute.pass? }
    
    Check.new(->{ Check.new {false} }) {|c|
      ! c.tap {|c| c.execute rescue nil } .pass? }
    Check.new(->{ Check.new {nil} }) {|c|
      ! c.tap {|c| c.execute rescue nil } .pass? }
  end
  
  Speck.new Check.instance_method :initialize do
    my_lambda = ->{}
    Check.new(->{ Check.new(&my_lambda) }) {|c| c.expectation == my_lambda }
    
    object = Object.new
    Check.new(->{ Check.new(my_lambda) {} }) {|c| c.target == my_lambda }
    Check.new(->{ Check.new(object) {} }) {|c| c.target.call == object }
  end
  
  Speck.new Check.instance_method :execute do
    Check.new(->{ Check.new {true} .execute }) {|c| c.pass? }
    
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
  end
  
end
