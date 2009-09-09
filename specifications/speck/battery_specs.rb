require_relative '../speck_helper'

require 'speck_specs'

require 'speck/battery'
Speck::SpeckBattery[Speck] << Speck.new(Speck::Battery) do
  
  Speck.new Speck, Speck::Battery, Speck::Battery.instance_method(:initialize) do
    Speck::Check.new(->{ Speck::Battery.new }) {|b| not b.specks.nil? }
    Speck::Check.new(->{ Speck::Battery.new }) {|b| b.specks.is_a? Array }
  end
  
  Speck.new Speck, Speck::Battery, Speck::Battery.instance_method(:[]) do
    battery = Speck::Battery.new
    object =  Object.new
    speck =   Smock.new.target {object}.mock!
    Speck::Check.new(->{ battery << speck; battery[object] }) {|b| not b.nil? }
    Speck::Check.new(->{ battery << speck; battery[object] }) {|b| b.is_a? Speck::Battery }
  end
  
  Speck.new Speck, Speck::Battery, Speck::Battery.instance_method(:<<) do
    
    battery = Speck::Battery.new
    object =  Object.new
    speck =   Smock.new.target {object}.mock!
    Speck::Check.new(->{ battery << speck }) {|b| not b[object].nil? }
    Speck::Check.new(->{ battery << speck }) {|b| b.specks.include? speck }
  end
  
end
