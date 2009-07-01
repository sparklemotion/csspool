module CSSPool
  module Selectors
    class Class < CSSPool::Selectors::Additional
      attr_accessor :name

      def initialize name
        @name = name
      end
    end
  end
end
