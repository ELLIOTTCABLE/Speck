class Speck
  ##
  # Represents a queued thing to be checked of some sort, within a `Speck`.
  class Check
    ##
    # The block to be executed, determining the success or failure of this
    # particular `Check`
    attr_accessor :block
    
    ##
    # A description for the check (usually a relevant line of source)
    attr_accessor :description
    
    ##
    # The status of the `Check`. `nil` indicates the `Check` hasn’t been
    # executed, and `true` or `false` indicate the success of the latest
    # execution
    attr_accessor :status
    alias_method :pass?, :status
    Speck.new Check.instance_method :pass? do
      object = Object.new
      
      Check.new {true} .execute.pass?.check
      Check.new {object} .execute.pass?.check
      
      ! Check.new {false} .tap {|c| c.execute rescue nil } .pass?.check
      ! Check.new {nil} .tap {|c| c.execute rescue nil } .pass?.check
    end
    
    def initialize(description = "<undocumented>", &block)
      @block = block
      @description = description
    end
    Speck.new Check.instance_method :initialize do
      my_lambda = ->{}
      Check.new(&my_lambda).check {|c| c.block == my_lambda }
      
      Check.new("WOO! BLANK CHECK!") {}
        .check {|c| c.description == "WOO! BLANK CHECK!" }
    end
    
    ##
    # Executes this `Check`, raising an error if the block returns nil or
    # false.
    def execute
      @status = @block.call ? true : false
      raise Exception::CheckFailed unless pass?
      return self
    end
    Speck.new Check.instance_method :execute do
      Check.new {true} .execute.check {|c| c.pass? }
      
      ->{ Check.new {false} .execute }
        .check_exception Speck::Exception::CheckFailed
      
      a_check = Check.new {true}
      a_check.execute.check {|rv| rv == a_check }
    end
    
  end
end
