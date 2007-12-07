require 'set'
module CSS
  class StyleSheet
    class Rule
      include Comparable

      attr_accessor :selector, :properties, :index
      def initialize(selector, index, properties = [])
        @selector = selector
        @properties = Set.new(properties)
        @index = index
      end

      def <=>(other)
        comp = selector.specificity <=> other.selector.specificity
        comp == 0 ? index <=> other.index : comp
      end
    end
  end
end
