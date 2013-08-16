module CSSPool
  module Selectors
    class Attribute < CSSPool::Selectors::Additional
      attr_accessor :name
      attr_accessor :value
      attr_accessor :match_way
      attr_accessor :namespace

      NO_MATCH  = 0
      SET       = 1
      EQUALS    = 2
      INCLUDES  = 3
      DASHMATCH = 4
      PREFIXMATCH = 5
      SUFFIXMATCH = 6
      SUBSTRINGMATCH = 7

      def initialize name, value, match_way, namespace = nil
        @name = name
        @value = value
        @match_way = match_way
        @namespace = namespace
      end
    end
  end
end
