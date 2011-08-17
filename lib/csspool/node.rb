module CSSPool
  class Node
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
    alias :eql? :==

    def each &block
      accept Visitors::Iterator.new block
    end

    def children
      accept Visitors::Children.new
    end

    def hash
      @hash ||= children.map { |child| child.hash }.hash
    end
  end
end
