module CSS
  module SAC
    class Selector
      attr_reader :selector_type
    end

    class SimpleSelector < Selector
      def initialize
        @selector_type = :SAC_ANY_NODE_SELECTOR
      end
    end

    class ElementSelector < SimpleSelector
      attr_reader :local_name
      alias :name :local_name

      def initialize(name)
        super()
        @selector_type = :SAC_ELEMENT_NODE_SELECTOR
        @local_name = name
      end
    end

    class ConditionalSelector < SimpleSelector
      attr_accessor :condition, :simple_selector
      alias :selector :simple_selector

      def initialize(selector, condition)
        @condition  = condition
        @simple_selector   = selector
        @selector_type = :SAC_CONDITIONAL_SELECTOR
      end
    end

    class DescendantSelector < SimpleSelector
      attr_accessor :ancestor_selector, :simple_selector
      alias :selector :simple_selector

      def initialize(ancestor, selector, type)
        @ancestor_selector = ancestor
        @simple_selector = selector
        @selector_type = type
      end
    end

    class SiblingSelector < SimpleSelector
      attr_accessor :selector, :sibling_selector
      def initialize(selector, sibling)
        @selector = selector
        @sibling_selector = sibling
        @selector_type = :SAC_DIRECT_ADJACENT_SELECTOR
      end
    end
  end
end
