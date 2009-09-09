require_relative '../speck_helper'

require 'speck_specs'

require 'speck/check'
Speck::SpeckBattery[Speck] << Speck.new(Speck::Check) do
  
  Speck.new Speck::Check.instance_method :passed? do
    object = Object.new
    
    Speck::Check.new(->{ Speck::Check.new {true} }) {|c| c.execute.passed? }
    Speck::Check.new(->{ Speck::Check.new {object} }) {|c| c.execute.passed? }
    
    Speck::Check.new(->{ Speck::Check.new {false} }) {|c|
      ! c.tap {|c| c.execute rescue nil } .passed? }
    Speck::Check.new(->{ Speck::Check.new {nil} }) {|c|
      ! c.tap {|c| c.execute rescue nil } .passed? }
  end
  
  Speck.new Speck::Check.instance_method :initialize do
    my_lambda = ->{}
    Speck::Check.new(->{ Speck::Check.new(&my_lambda) }) {|c| c.expectation == my_lambda }
    
    object = Object.new
    Speck::Check.new(->{ Speck::Check.new(my_lambda) {} }) {|c| c.target == my_lambda }
    Speck::Check.new(->{ Speck::Check.new(object) {} }) {|c| c.target.call == object }
  end
  
  Speck.new Speck::Check.instance_method :execute do
    Speck::Check.new(->{ Speck::Check.new {true} .execute }) {|c| c.passed? }
    Speck::Check.new(->{ ->{ Speck::Check.new {false} .execute } }) do |block|
      begin
        block.call
        false
      rescue Speck::Exception::CheckFailed
        true
      end
    end
    
    a_check = Speck::Check.new {true}
    Speck::Check.new(->{ a_check.execute }) {|rv| rv == a_check }
    
    object = Object.new
    Speck::Check.new(->{ Speck::Check.new(object) {|passed| @passed = passed } }) {|c|
      c.execute; @passed == object }
    
    Speck::Check.new(->{ Speck::Check.new(->{ @called = true }) {true} }) {|c|
      c.execute; @called }
  end
  
end
