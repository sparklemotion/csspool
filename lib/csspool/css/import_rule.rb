module CSSPool
  module CSS
    class ImportRule < Struct.new(:uri, :namespace, :media, :document, :parse_location)
      include CSSPool::Visitable

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
