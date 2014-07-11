module CSSPool
  module CSS
    class MediaQueryList < CSSPool::Node
      attr_accessor :media_queries, :parse_location, :rule_sets

      def initialize(media_queries = [], parse_location = {})
        @media_queries = media_queries
        @parse_location = parse_location
        @rule_sets = []
      end

      def <<(media_query)
        media_queries << media_query
        self
      end
      alias push <<

      def length
        media_queries.length
      end
      alias size length

      def first
        media_queries.first
      end

      def last
        media_queries.last
      end

      def [](idx)
        media_queries[idx]
      end

      def inspect
        media_queries.inspect
      end

    end
  end
end
