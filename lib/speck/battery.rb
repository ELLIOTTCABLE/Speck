class Speck
  ##
  # A `Battery` of `Speck`s is a set of specks which should be executed
  # together, and which interdepend upon other `Speck`s in the battery.
  # `Batteries` are recursive structures; that is, a `Battery` may have sub–
  # `Batteries` for relevant objects.
  class Battery
    
    attr_reader :specks
    attr_reader :targets
    
    def initialize
      @specks = Array.new
      @targets = Hash.new
    end
    
    def << speck
      @specks << speck
      @targets[speck.target] ||= Battery.new
      return self
    end
    
    def [] object
      return @targets[object]
    end
    
  end
end
