module CSSPool
  module Selectors
    class Simple < CSSPool::Node

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
