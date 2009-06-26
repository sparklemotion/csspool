module Crocodile
  class Collection
    include Enumerable

    ###
    # Create a new Collection.  +block+ is used to resolve any @import
    # statements.  You are responsible for fetching and returning any CSS
    # documents that are refered to in @import statements.
    def initialize &block
      @docs   = []
      @block  = block
    end

    ###
    # Add a new CSS document to this collection stored in +string+.  Any
    # @import statements will call the +block+ set in initialize to resolve
    # dependencies.
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

      @docs += import_tree.flatten.reverse
      self
    end

    ###
    # Get the length of this collection
    def length
      @docs.length
    end

    ###
    # Get the Crocodile::CSS::Document at index +idx+
    def [] idx
      @docs[idx]
    end

    ###
    # Iterate over each Crocodile::CSS::Document yielding the document to
    # +block+.
    def each &block
      @docs.each &block
    end

    ###
    # Get the last document in this collection
    def last
      @docs.last
    end

    ###
    # Apply this collection to +doc+.
    def apply_to doc
      each do |css_doc|
        css_doc.apply_to doc
      end
    end
  end
end
