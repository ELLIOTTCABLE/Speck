($:.unshift File.expand_path(File.join(
  File.dirname(__FILE__), 'lib' ))).uniq!
require 'speck'
require 'slack'

require 'speck/check'

Speck.new Speck::Check do |target|
  Check = Speck::Check
  
  Speck.new Check.instance_method :pass? do
    object = Object.new
    
    Check.new {true} .execute.pass?.check
    Check.new {object} .execute.pass?.check
    
    ! Check.new {false} .tap {|c| c.execute rescue nil } .pass?.check
    ! Check.new {nil} .tap {|c| c.execute rescue nil } .pass?.check
  end
  
  Speck.new Check.instance_method :initialize do
    my_lambda = ->{}
    Check.new(&my_lambda).check {|c| c.expectation == my_lambda }
  end
  
  Speck.new Check.instance_method :execute do
    Check.new {true} .execute.check {|c| c.pass? }
    
    ->{ Check.new {false} .execute }
      .check_exception Speck::Exception::CheckFailed
    
    a_check = Check.new {true}
    a_check.execute.check {|rv| rv == a_check }
  end
  
end
