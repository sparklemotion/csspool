require 'set'
module CSS
  class StyleSheet
    class Rule
      attr_accessor :selector, :properties
      def initialize(selector, properties = [])
        @selector = selector
        @properties = Set.new(properties)
      end
    end
  end
end
