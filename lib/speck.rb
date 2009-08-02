require 'speck/core_ext'
require 'speck/check'

class Speck
  
  class <<self
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
    
    ##
    # Prepares `Speck` for use (currently only monkey–patches `Object` with
    # `Speck::ObjectMixins`)
    def prepare
      ::Object.send :include, Speck::ObjectMixins
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
  end
  
  ##
  # Executes the `Speck`.
  def execute
    Speck::prepare
    
    Speck.stack << self
    speck.call
    Speck.stack.pop
  end
  
  ##
  # Executes the `Speck`, and prints the status of each `Check`
  # --
  # TODO: Fix the naming of this and `#execute`
  # TODO: Get rid of this, printing should be up to the rake task at best, or
  #       non–existent at worst. Keep it light!
  def playback
    execute
    checks.each {|c| puts "`#{c.description}`"; c.execute }
  end
  
  
  ##
  # A root class, and container class, for `Speck` exceptions.
  class Exception < Exception
    # Raised any time checks are run outside of a `Speck`
    NoEnvironment = Class.new self
    
    # Raised when a `Check` fails
    CheckFailed = Class.new self
  end
  
end
