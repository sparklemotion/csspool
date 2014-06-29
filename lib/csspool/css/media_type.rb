module CSSPool
  module CSS
    class MediaType < CSSPool::Node
      attr_accessor :name
      attr_accessor :parse_location
      attr_accessor :rule_sets

      def initialize(name, parse_location = {})
        @name = name
        @parse_location = parse_location
        @rule_sets = []
      end

      alias value name
    end
  end
end
