require "css/sac/selectors"

module CSS
  module SAC
    module Selectors
      class DescendantSelector < SimpleSelector
        attr_accessor :ancestor_selector, :simple_selector
        alias :ancestor :ancestor_selector
        alias :selector :simple_selector

        def initialize(ancestor, selector)
          super(:SAC_DESCENDANT_SELECTOR)

          @ancestor_selector = ancestor
          @simple_selector = selector
        end

        def to_css
          "#{ancestor.to_css} #{selector.to_css}"
        end

        def to_xpath(prefix=true)
          "#{ancestor.to_xpath(prefix)}//#{selector.to_xpath(false)}"
        end

        def specificity
          ancestor.specificity + selector.specificity
        end

        def ==(other)
          super && selector == other.selector && ancestor == other.ancestor
        end

        def =~(node)
          return false unless super
          return false unless node.respond_to?(:parent)
          return false if node.parent.nil?
          return false unless selector =~ node

          parent = node.parent
          loop {
            return true if ancestor =~ parent
            return false unless node.respond_to?(:parent)
            parent = parent.parent
          }
          false
        end
      end
    end
  end
end
