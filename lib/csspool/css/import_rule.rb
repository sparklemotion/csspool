module CSSPool
  module CSS
    class ImportRule < CSSPool::Node
      attr_accessor :uri
      attr_accessor :namespace
      attr_accessor :media_list
      attr_accessor :document
      attr_accessor :parse_location

      def initialize uri, namespace, media_list, document, parse_location
        @uri = uri
        @namespace = namespace
        @media_list = media_list
        @document = document
        @parse_location = parse_location
      end

      def load
        new_doc = CSSPool.CSS(yield uri.value)
        new_doc.parent_import_rule = self
        new_doc.parent = document
        # we'll make a "fake" media rule if this import specified media to apply to the rulesets
        if !media_list.empty?
            media = CSS::Media.new(media_list, parse_location)
            new_doc.rule_sets.each { |rs| rs.media = media }
        end
        new_doc
      end
    end
  end
end
