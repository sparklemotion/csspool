require 'css/sac' # bleh module stuff

module CSS
  class SAC # grr annoying: should be a module?
    class Lexeme
      attr_reader :name, :pattern
      
      def initialize(name, pattern=nil, &block)
        raise ArgumentError, "name required" unless name
        
        @name = name
        patterns = []
        
        patterns << pattern if pattern

        # allow lots of patterns to be specified with 'match'
        yield(patterns) if block_given?
        
        if patterns.empty?
          raise ArgumentError, "at least one pattern required"
        end
        
        patterns.collect! do |pattern|
          source = pattern.source
          source = "^#{source}" unless source[0] == ?^
          Regexp.new(source, Regexp::IGNORECASE)
        end

        @pattern = Regexp.union(*patterns)
      end
    end
  end
end
