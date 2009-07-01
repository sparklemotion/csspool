module CSSPool
  module CSS
    class RuleSet < Struct.new(:selectors, :declarations, :media)
      include CSSPool::Visitable

      def initialize selectors, declarations = [], media = []
        selectors.each { |sel| sel.rule_set = self }
        super
      end
    end
  end
end
