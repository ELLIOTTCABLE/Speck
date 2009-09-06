class Speck
  ##
  # Represents a queued thing to be checked of some sort, within a `Speck`.
  class Check
    ##
    # The block to be executed, determining the success or failure of this
    # particular `Check`. If it accepts an argument, the result of the target
    # block will be passed as that argument.
    attr_accessor :expectation
    
    ##
    # The `target` of a `Check` is a block that returns an object to be passed
    # to the `expectation`. It represents the object that the `Check` is
    # intended to, well, check.
    attr_accessor :target
    
    ##
    # The status of the `Check`. `nil` indicates the `Check` hasn’t been
    # executed, and `true` or `false` indicate the success of the latest
    # execution
    attr_accessor :status
    alias_method :pass?, :status
    
    def initialize(target = nil, &expectation)
      @target = target.respond_to?(:call) ? target : ->{target}
      @expectation = expectation
      Speck.current.checks << self if Speck.current
    end
    
    ##
    # Executes this `Check`, raising an error if the expectation returns nil
    # or false.
    def execute
      call = @expectation.arity == 0 ? ->{@expectation.call} : ->{@expectation[@target.call]}
      @status = call.call ? true : false
      raise Exception::CheckFailed unless pass?
      return self
    end
    
  end
end
