require 'set'
module CSS
  class StyleSheet
    class Rule
      include Comparable

      attr_accessor :selector, :properties
      def initialize(selector, properties = [])
        @selector = selector
        @properties = Set.new(properties)
      end

      def <=>(other)
        selector.specificity <=> other.selector.specificity
      end
    end
  end
end
