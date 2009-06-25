module Crocodile
  class Collection
    def initialize &block
      @docs   = []
      @block  = block
    end

    def << string
      doc = Crocodile.CSS string
      doc.import_rules.each do |ir|
        @docs << ir.load(&@block)
      end
      @docs << doc
      self
    end

    def length
      @docs.length
    end
  end
end
