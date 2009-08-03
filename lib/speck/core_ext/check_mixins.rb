class Speck
  ##
  # These methods, when mixed into `Object`, provide some conveniences when it
  # comes to checking things in your `Speck`s.
  module ObjectMixins
    
    ##
    # This method is responsible for running some sort of test on the
    # receiver.
    # 
    # It expects a block (returning true or false) to be passed. The block
    # will be passed the receiver, so you can run comparators on it, or
    # whatever else you like.
    # 
    # `#check` can also be called without block on truthy objects (`true`,
    # `false`, or `nil`)
    def check &check
      check = ->(_){self} unless block_given?
      
      file, line, _ = Kernel::caller.first.split(':')
      source = File.open(file).readlines[line.to_i - 1]
      source.strip!
      source = source.partition(".check").first
      
      # TODO: Should we allow specks in the root environment? Could be useful
      #       for quick checks…
      raise Exception::NoEnvironment unless Speck.current
      Speck.current.checks <<
        Speck::Check.new(->(){ check[self] }, source)
    end
    
  end
end