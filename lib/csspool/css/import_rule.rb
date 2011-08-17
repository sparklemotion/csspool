module CSSPool
  module CSS
    class ImportRule < CSSPool::Node
      attr_accessor :uri
      attr_accessor :namespace
      attr_accessor :media
      attr_accessor :document
      attr_accessor :parse_location

      def initialize uri, namespace, media, document, parse_location
        @uri = uri
        @namespace = namespace
        @media = media
        @document = document
        @parse_location = parse_location
      end

      def load
        new_doc = CSSPool.CSS(yield uri.value)
        new_doc.parent_import_rule = self
        new_doc.parent = document
        new_doc.rule_sets.each { |rs| rs.media = media }
        new_doc
      end
    end
  end
end
