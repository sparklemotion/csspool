module CSSPool
  module CSS
    class NamespaceRule < CSSPool::Node
      attr_accessor :prefix
      attr_accessor :uri

      def initialize prefix, uri
        @prefix = prefix
        @uri = uri
      end
    end
  end
end
