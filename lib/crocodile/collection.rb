module Crocodile
  class Collection
    def initialize &block
      @docs   = []
      @block  = block
    end

    def << string
      doc = Crocodile.CSS string

      import_tree = [[doc]]

      imported_urls = {}

      until import_tree.last.all? { |x| x.import_rules.length == 0 }
        level = import_tree.last
        import_tree << []
        level.each do |doc|
          doc.import_rules.each do |ir|
            next if imported_urls.key? ir.uri

            new_doc = ir.load(&@block)

            imported_urls[ir.uri] = ir.load(&@block)
            import_tree.last << new_doc
          end
        end
      end

      @docs += import_tree.flatten
      self
    end

    def length
      @docs.length
    end

    def [] idx
      @docs[idx]
    end
  end
end
