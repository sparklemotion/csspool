module CSSPool
  module CSS
    class Declaration < CSSPool::Node
      attr_accessor :property
      attr_accessor :expressions
      attr_accessor :important
      attr_accessor :rule_set

      alias :important? :important

      def initialize property, expressions, important, rule_set
        @property = property
        @expressions = expressions
        @important = important
        @rule_set = rule_set
      end
    end
  end
end
