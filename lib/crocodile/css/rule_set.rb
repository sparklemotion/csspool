module Crocodile
  module CSS
    class RuleSet < Struct.new(:selectors, :declarations, :parent_media)
      def initialize selectors, declarations = [], parent_media = nil
        super
      end
    end
  end
end
