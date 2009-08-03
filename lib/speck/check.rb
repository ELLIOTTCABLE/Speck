class Speck
  ##
  # Represents a queued thing to be checked of some sort, within a `Speck`.
  class Check
    ##
    # A block to be executed.
    attr_accessor :lambda
    
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
      Check.new(->{true}).execute.status
        .check {|s| s == true}
      Check.new(->{42}).execute.status
        .check {|s| s == 42}
      
      Check.new(->{true}).execute.success?.check
      Check.new(->{42}).execute.success?.check
    end
    
    def initialize(lambda, description = "<undocumented>")
      @lambda = lambda
      @description = description
    end
    Speck.new Check, :new do
      my_lambda = ->{}
      Check.new(my_lambda).lambda.check {|l| l == my_lambda }
      
      Check.new(->{}, "WOO! BLANK CHECK!").description
        .check {|d| d == "WOO! BLANK CHECK!" }
    end
    
    ##
    # Executes this `Check`, raising an error if the block returns nil or
    # false.
    def execute
      @status = @lambda.call
      raise Exception::CheckFailed unless success?
      self
    end
    Speck.new :execute do
      Check.new(->{true}).execute.check {|c| c.success? }
      ->{ Check.new(->{false}).execute }
        .check_exception Speck::Exception::CheckFailed
      
      Check.new(->{"value"}).execute.check
      Check.new(->{2 * 2}).execute.check {|value| value == 4 }
    end
    
  end
end
