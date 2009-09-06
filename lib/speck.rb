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
    # Retreives the `Speck`s defiend for a given object, or, if none are
    # defined, creates a new (empty) `Speck` for it.
    # 
    # It’s worth noting that `Module#instance_method` returns a new
    # `UnboundMethod` object every time you call it, even for the same method…
    # so you can’t retreive Specks assigned to `UnboundMethods` via
    # `Module#instance_method` with this method.
    def for object
      specks = Speck::on object
      specks << Speck.new(object) if specks.empty?
      return specks
    end
    
    ##
    # Functions like `Speck::for`, without creating a new `Speck` if none are
    # defined.
    # 
    # @see `Speck::for`
    def on object
      object.instance_variable_get(NinjaVar) ||
        object.instance_variable_set(NinjaVar, Array.new)
    end
    
  end
  
  ##
  # This instance variable will be set on target objects to point to the
  # specks for that object
  NinjaVar = :@_specks_
  
  ##
  # The block to be executed
  attr_accessor :block
  
  ##
  # `Speck`s which consider this `Speck` to be their environment
  attr_accessor :children
  def children; @children ||= Array.new; end
  
  ##
  # The `environment` of a `Speck` is another `Speck`, describing some sort of
  # parent. The environment of a `Speck` describing an `UnboundMethod`, for
  # instance, would most likely be a `Speck` describing a `Module` or `Class`
  # on which that method is defined
  attr_accessor :environment
  def environment= object
    (@environment ? @environment.children : Speck.unbound).delete self
    
    speck = object.is_a?(Speck) || object.nil? ?
      object : Speck::for(object).first
    @environment = speck
    
    (@environment ? @environment.children : Speck.unbound) << self
  end
  
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
    Speck::on(@target).delete self if @target and Speck::on(@target).include? self
    
    @target = object
    
    Speck::on(@target) << self
  end
  
  ##
  # Creates a new `Speck`.
  def initialize *environment, object, &block
    self.target = object
    
    environment = environment.inject do |prev, curr|
      raise 'pre-existing environment!' if Speck::for(curr).first.environment and Speck::for(curr).first.environment != Speck::for(prev).first
      Speck::for(curr).first.environment = Speck::for(prev).first
      curr
    end
    
    self.environment = environment ? Speck::for(environment).first : Speck.current
    @block = block || lambda {}
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
    # Raised when a `Check` fails
    CheckFailed = Class.new self
  end
  
end

require 'speck/check'
