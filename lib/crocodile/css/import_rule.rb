module Crocodile
  module CSS
    class ImportRule < Struct.new(:uri, :namespace, :media, :document, :parse_location)
      include Crocodile::Visitable

      def load
        new_doc = Crocodile.CSS(yield uri)
        new_doc.parent_import_rule = self
        new_doc.parent = document
        new_doc.rule_sets.each { |rs| rs.media = media }
        new_doc
      end
    end
  end
end
