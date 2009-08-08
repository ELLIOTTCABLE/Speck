class Speck
  ##
  # Represents a queued thing to be checked of some sort, within a `Speck`.
  class Check
    ##
    # The block to be executed, determining the success or failure of this
    # particular `Check`
    attr_accessor :block
    
    ##
    # A description of the `Check`’s target—that is, what it is checking (this
    # is often a line of source describing how the target was constructed)
    attr_accessor :target
    
    ##
    # A description of the `Check`’s expectation—that is, what it expects
    # about its `target` (again, this is usually a short ’n’ sweet line of
    # source containing a comparator)
    attr_accessor :expectation
    
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
    
    def initialize(target = "<unknown>", expectation = "<unknown>", &block)
      @target = target
      @expectation = expectation
      @block = block
    end
    Speck.new Check.method :new do
      my_lambda = ->{}
      Check.new(&my_lambda).check {|c| c.block == my_lambda }
      
      Check.new('Absolutely nothing.') {}
        .check {|c| c.target == 'Absolutely nothing.' }
      
      Check.new('nothing', 'who cares') {}
        .check {|c| c.expectation == 'who cares' }
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
