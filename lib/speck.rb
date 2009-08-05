# All library files are required at the bottom, because in this unique case we
# need `Speck` defined before we can use it to `Speck` anything.

class Speck
  Version = 0
  
  class <<self
    
    ##
    # All defined Specks.
    attr_accessor :specks
    def specks; @specks ||= Array.new; end
    
    ##
    # The current stack of nested `Speck`s.
    # 
    # @see #current
    attr_accessor :stack
    def stack; @stack ||= Array.new; end
    
    ##
    # Returns the currently active `Speck`.
    # 
    # When your `Speck`s are being run, there is a `stack` of `Speck` objects,
    # consisting of the current nesting list of `Speck`s being run.
    def current
      stack.last
    end
  end
  
  ##
  # The block to be executed
  attr_accessor :speck
  
  ##
  # Child `Speck`s
  attr_accessor :children
  def children; @children ||= Array.new; end
  
  ##
  # Parent `Speck`
  attr_accessor :parent
  
  ##
  # The checks involved in the current `Speck`.
  attr_accessor :checks
  def checks; @checks ||= Array.new; end
  
  ##
  # Creates a new `Speck`.
  def initialize *targets, &speck
    @speck = speck
    @parent = Speck.current
    
    @parent.children << self if @parent
    Speck.specks << self
  end
  
  ##
  # Executes the `Speck`.
  def execute
    Speck.stack << self
    speck.call
    Speck.stack.pop
  end
  
  
  ##
  # A root class, and container class, for `Speck` exceptions.
  class Exception < StandardError
    # Raised any time checks are run outside of a `Speck`
    NoEnvironment = Class.new self
    
    # Raised when a `Check` fails
    CheckFailed = Class.new self
  end
  
end

require 'speck/check'
