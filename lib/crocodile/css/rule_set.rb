module Crocodile
  module CSS
    class RuleSet < Struct.new(:selectors, :declarations, :media)
      include Crocodile::Visitable

      def initialize selectors, declarations = [], media = []
        selectors.each { |sel| sel.rule_set = self }
        super
      end
    end
  end
end
