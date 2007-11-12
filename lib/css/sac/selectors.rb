module CSS
  module SAC
    class Selector
      attr_reader :selector_type
    end

    class SimpleSelector < Selector
      def initialize
        @selector_type = :SAC_ANY_NODE_SELECTOR
      end

      def to_css
        '*'
      end
      
      def to_xpath
        "//*"
      end

      def specificity
        0
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

      def to_css
        local_name
      end
      
      def to_xpath(prefix=true)
        atoms = [local_name]
        atoms.unshift("//") if prefix
        atoms.join
      end

      def specificity
        1
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

      def to_css
        [selector, condition].map { |x|
          x ? x.to_css : ''
        }.join('')
      end
      
      def to_xpath(prefix=true)
        atoms = []
        atoms << "//" if prefix
        atoms << (selector ? selector.to_xpath(false) : "*")
        atoms << condition.to_xpath
        
        atoms.join("")
      end

      def specificity
        (selector ? selector.specificity : 0) +
          (condition ? condition.specificity : 0)
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

      def to_css
        separator =
          case @selector_type
          when :SAC_CHILD_SELECTOR
            ' > '
          when :SAC_DESCENDANT_SELECTOR
            ' '
          end
        ancestor_selector.to_css + separator + selector.to_css
      end
      
      def to_xpath(prefix=true)
        separator =
          case @selector_type
          when :SAC_CHILD_SELECTOR
            "/"
          when :SAC_DESCENDANT_SELECTOR
            "//"
          end
        ancestor_selector.to_xpath(prefix) + separator + selector.to_xpath(false)
      end

      def specificity
        ancestor_selector.specificity + selector.specificity
      end
    end

    class SiblingSelector < SimpleSelector
      attr_accessor :selector, :sibling_selector
      def initialize(selector, sibling)
        @selector = selector
        @sibling_selector = sibling
        @selector_type = :SAC_DIRECT_ADJACENT_SELECTOR
      end

      def to_css
        selector.to_css + ' + ' + sibling_selector.to_css
      end
      
      def to_xpath(prefix=true)
        selector.to_xpath(prefix) + "/following-sibling::" + sibling_selector.to_xpath(false)
      end

      def specificity
        selector.specificity + sibling_selector.specificity
      end
    end
  end
end
