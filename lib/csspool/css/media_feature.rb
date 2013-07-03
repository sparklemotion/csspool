module CSSPool
  module CSS
    class MediaFeature < CSSPool::Node
      attr_accessor :property, :value
      attr_accessor :parse_location

      def initialize(property, value, parse_location = {})
        @property = property
        @value = value
        @parse_location = parse_location
      end
    end
  end
end
