module CSSPool
  module Selectors
    class PseudoElement < CSSPool::Selectors::Additional
      attr_accessor :name
      attr_accessor :css2

      def initialize name, css2 = nil
        @name = name
        @css2 = css2
      end
    end
  end
end
