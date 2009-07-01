module Crocodile
  module Selectors
    class Attribute < Crocodile::Selectors::Additional
      attr_accessor :name
      attr_accessor :value
      attr_accessor :match_way

      NO_MATCH  = 0
      SET       = 1
      EQUALS    = 2
      INCLUDES  = 3
      DASHMATCH = 4

      def initialize name, value, match_way
        @name = name
        @value = value
        @match_way = match_way
      end
    end
  end
end
