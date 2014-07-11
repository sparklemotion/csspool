module CSSPool
  module CSS
    class RuleSet < CSSPool::Node
      attr_accessor :selectors
      attr_accessor :declarations
      attr_accessor :parent_rule

      def initialize selectors, declarations = [], parent_rule = nil
        @selectors    = selectors
        @declarations = declarations
        @parent_rule  = parent_rule

        selectors.each { |sel| sel.rule_set = self }
      end

    end
  end
end
