module CSSPool
  module CSS
    class Media < CSSPool::Node
      attr_accessor :media_list
      attr_accessor :parse_location
      attr_accessor :rule_sets

      def initialize media_list, parse_location
        @media_list = media_list
        @parse_location = parse_location
        @rule_sets = []
      end
    end
  end
end
