module CSSPool
  module Visitable
    def accept target
      target.accept self
    end

    def to_css
      accept Visitors::ToCSS.new
    end
    alias :to_s :to_css

    def == other
      return false unless self.class == other.class

      accept Visitors::Comparable.new other
    end

    def each &block
      accept Visitors::Iterator.new block
    end
  end
end
