class Speck
  ##
  # Represents a queued thing to be checked of some sort, within a `Speck`.
  class Check
    ##
    # A block to be executed.
    attr_accessor :check
    
    ##
    # A description for the check. Usually a relevant line of code.
    attr_accessor :description
    
    def initialize(check, description = "<undocumented>")
      @check = check
      @description = description
    end
    
    ##
    # Executes this `Check`, raising an error if the block returns nil or
    # false.
    def execute
      @check.call.tap {|succeeded| raise Exception::CheckFailed unless succeeded }
    end
    Speck.new :execute do
       Check.new(->{true}).execute.check
       ->{ Check.new(->{false}).execute }.check_exception Speck::Exception::CheckFailed
    end
    
  end
end
