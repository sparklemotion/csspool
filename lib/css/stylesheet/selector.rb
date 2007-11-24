require 'set'
module CSS
  class StyleSheet
    class Selector
      attr_accessor :ast, :properties
      def initialize(ast, properties = [])
        @ast = ast
        @properties = Set.new(properties)
      end

      def eql?(other)
        ast.eql?(other.ast)
      end

      def hash
        ast.hash
      end
    end
  end
end
