module Crocodile
  module CSS
    class RuleSet < Struct.new(:selectors, :declarations, :parent_media)
      include Crocodile::Visitable

      def initialize selectors, declarations = [], parent_media = nil
        selectors.each { |sel| sel.rule_set = self }
        super
      end
    end
  end
end
