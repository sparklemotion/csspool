module CSSPool
  module Selectors
    class Type < CSSPool::Selectors::Simple

      attr_accessor :namespace

      def initialize name, combinator = nil, namespace = nil
        super name, combinator
        @namespace = namespace
      end
    end
  end
end
