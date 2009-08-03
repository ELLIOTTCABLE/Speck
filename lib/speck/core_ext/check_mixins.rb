class Speck
  ##
  # These methods, when mixed into their respective classes, provide some
  # conveniences when it comes to creating `Check`s.
  module Mixins
    
    ##
    # This method will quickly mix all of our `Mixins` into their respective
    # targets.
    def self.mixin!
      Speck::Mixins.constants
        .map {|mod| Speck::Mixins.const_get(mod) }
        .each {|mod| mod::Target.send :include, mod }
    end
    
    module Object; Target = ::Object
      ##
      # This method is responsible for running some sort of test on the
      # receiver.
      # 
      # It expects a block (returning true or false) to be passed. The block
      # will be passed the receiver, so you can run comparators on it, or
      # whatever else you like.
      # 
      # `#check` can also be called without block on truthy objects (`true`,
      # `false`, or `nil`, any other object will be treated as `true`)
      def check &check
        check = ->(_){self} unless block_given?
        
        # TODO: Should we allow specks in the root environment? Could be useful
        #       for quick checks…
        raise Exception::NoEnvironment unless Speck.current
        
        file, line, _ = Kernel::caller.first.split(':')
        source = File.open(file).readlines[line.to_i - 1]
        source.strip!
        source = source.partition(".check").first
        # TODO: Get rid of the "(…)" around the resulting string.
        
        Speck.current.checks <<
          Speck::Check.new(->(){ check[self] }, source)
      end
    end
    
    module Proc; Target = ::Proc
      
      ##
      # This method is responsible for checking that a particular proc raises
      # a particular exception type when called.
      def check_exception exception = Exception
        # TODO: Should we allow specks in the root environment? Could be useful
        #       for quick checks…
        raise Exception::NoEnvironment unless Speck.current
        
        file, line, _ = Kernel::caller.first.split(':')
        source = File.open(file).readlines[line.to_i - 1]
        source.strip!
        source = source.partition(".check_exception").first
        # TODO: Get rid of the "->{…}" around the resulting string.
        
        Speck.current.checks <<
          Speck::Check.new(->(){
            begin
              self.call
            rescue exception
              return true
            end
            return false
          }, source)
      end
      
    end
  end
end
