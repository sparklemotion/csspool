module CSSPool
  module CSS
    class RuleSet < CSSPool::Node
      attr_accessor :selectors
      attr_accessor :declarations
      attr_accessor :media

      def initialize selectors, declarations = [], media = MediaQueryList.new
        @selectors    = selectors
        @declarations = declarations
        @media        = media

        selectors.each { |sel| sel.rule_set = self }
      end

      alias media_query_list media
    end
  end
end
