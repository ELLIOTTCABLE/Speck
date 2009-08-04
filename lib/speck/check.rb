class Speck
  ##
  # Represents a queued thing to be checked of some sort, within a `Speck`.
  class Check
    ##
    # A block to be executed.
    attr_accessor :block
    
    ##
    # A description for the check. Usually a relevant line of code.
    attr_accessor :description
    
    ##
    # The status of the `Check`. `nil` indicates the `Check` hasn’t been
    # executed, and `true` or `false` indicate the success of the latest
    # execution.
    attr_accessor :status
    
    ##
    # Checks the truthiness of this `Check`’s `status`.
    def success?
      !!status
    end
    Speck.new :status do
      object = Object.new
      Check.new(->{true}).execute.status
        .check {|s| s == true}
      Check.new(->{object}).execute.status
        .check {|s| s == object}
      
      Check.new(->{true}).execute.success?.check
      Check.new(->{object}).execute.success?.check
      
      Check.new(->{false}).tap {|c| c.execute rescue nil } .status
        .check {|s| s == false}
      Check.new(->{nil}).tap {|c| c.execute rescue nil } .status
        .check {|s| s == false}
    end
    
    def initialize(block, description = "<undocumented>")
      @block = block
      @description = description
    end
    Speck.new Check, :new do
      my_lambda = ->{}
      Check.new(my_lambda).block.check {|b| b == my_lambda }
      
      Check.new(->{}, "WOO! BLANK CHECK!").description
        .check {|d| d == "WOO! BLANK CHECK!" }
    end
    
    ##
    # Executes this `Check`, raising an error if the block returns nil or
    # false.
    def execute
      @block.call.tap {|result| @status = result ? result : false }
      raise Exception::CheckFailed unless success?
      return self
    end
    Speck.new :execute do
      Check.new(->{true}).execute.check {|c| c.success? }
      ->{ Check.new(->{false}).execute }
        .check_exception Speck::Exception::CheckFailed
      
      a_check = Check.new(->{true})
      a_check.execute.check {|rv| rv == a_check }
    end
    
  end
end
