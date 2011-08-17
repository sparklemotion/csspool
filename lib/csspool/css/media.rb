module CSSPool
  module CSS
    class Media < CSSPool::Node
      attr_accessor :name
      attr_accessor :parse_location

      def initialize name, parse_location
        @name = name
        @parse_location = parse_location
      end
    end
  end
end
