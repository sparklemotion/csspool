module Crocodile
  module Selectors
    class Simple < Crocodile::Node
      NO_COMBINATOR       = 0
      DESCENDENT          = 1
      PRECEDED_BY         = 2
      CHILD               = 3

      attr_accessor :name
      attr_accessor :parse_location
      attr_accessor :additional_selectors
      attr_accessor :combinator

      def initialize name, combinator = nil
        @name                 = name
        @combinator           = combinator
        @parse_location       = nil
        @additional_selectors = []
      end
    end
  end
end
