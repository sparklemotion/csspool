module CSSPool
  module CSS
    class MediaQuery < CSSPool::Node
      attr_accessor :only_or_not, :media_expr, :and_exprs
      attr_accessor :parse_location

      def self.empty
        new(nil, nil, [])
      end

      def initialize(only_or_not, media_expr, and_exprs, parse_location = {})
        @only_or_not = only_or_not
        @media_expr = media_expr
        @and_exprs = and_exprs
        @parse_location = parse_location
      end
    end
  end
end
