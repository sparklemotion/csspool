module CSSPool
  module Selectors
    class MediaExpression < CSSPool::Selectors::Additional
      attr_accessor :name
      attr_accessor :value

      def initialize name, value
        @name = name
        @value = value
      end
    end
  end
end
