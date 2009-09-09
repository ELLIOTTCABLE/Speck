require_relative 'speck_helper'

require 'speck'
Speck::SpeckBattery = Speck::Battery.new

Speck::SpeckBattery << Speck.new(Speck) do
  
end
