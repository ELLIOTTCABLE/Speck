# All library files are required at the bottom, because in this unique case we
# need `Speck` defined before we can use it to `Speck` anything.

class Speck
  Version = 0
  
  class <<self
    
    ##
    # All specks not bound to an environment
    attr_accessor :unbound
    def unbound; @unbound ||= Array.new; end
    
    # The current `Speck` execution stack
    # 
    # @see #current
    attr_accessor :stack
    def stack; @stack ||= Array.new; end
    
    ##
    # Returns the top `Speck` on the execution stack (the one currently in the
    # process of executing)
    # 
    # When your `Speck`s are being run, there is a `stack` of `Speck` objects,
    # consisting of the current nesting list of `Speck`s being run.
    def current
      stack.last
    end
    
    ##
    # Retreives the `Speck`s defiend for a given object, if any.
    def for object
      object.instance_variable_get(NinjaVar) || object.instance_variable_set(NinjaVar, Array.new)
    end
    
  end
  
  ##
  # This instance variable will be set on target objects to point to the
  # specks for that object
  NinjaVar = :@specks
  
  ##
  # The block to be executed
  attr_accessor :block
  
  ##
  # Child `Speck`s
  attr_accessor :children
  def children; @children ||= Array.new; end
  
  ##
  # The `environment` of a `Speck` is another `Speck`, describing some sort of
  # parent. The environment of a `Speck` describing an `UnboundMethod`, for
  # instance, would most likely be a `Speck` describing a `Module` or `Class`
  # on which that method is defined
  attr_accessor :environment
  
  ##
  # The checks involved in the current `Speck`
  attr_accessor :checks
  def checks; @checks ||= Array.new; end
  
  ##
  # The `target` of a speck is usually the object which it is intended to
  # describe (and test) the functionality of (Usually, this will be an
  # instance of `Class`, `Module`, `Method` for “class” methods, or
  # `UnboundMethod` for instance methods)
  attr_accessor :target
  def target= object
    Speck::for(@target).delete self if @target and Speck::for(@target).include? self
    
    @target = object
    
    Speck::for(@target) << self
  end
  
  ##
  # Creates a new `Speck`.
  def initialize object, _={}, &block
    raise ArgumentError, 'environment must be a Speck' if _[:environment] &&!
      _[:environment].is_a?(Speck)
    
    self.target = object
    
    @environment = _[:environment] || Speck.current
    (@environment ? @environment.children : Speck.unbound) << self
    
    @block = block
  end
  
  ##
  # Executes the `Speck`.
  def execute
    Speck.stack << self
    @block.call
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
