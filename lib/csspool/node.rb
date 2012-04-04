module CSSPool
  class Node
    include Enumerable

    def accept target
      target.accept self
    end

    def to_css options={}
      if options[:minify]
        to_minified_css
      else
        accept Visitors::ToCSS.new
      end
    end
    alias :to_s :to_css

    def to_minified_css
      accept Visitors::ToMinifiedCSS.new
    end

    def == other
      return false unless self.class == other.class

      accept Visitors::Comparable.new other
    end
    alias :eql? :==

    def each &block
      Visitors::Iterator.new(block).accept self
    end

    def children
      accept Visitors::Children.new
    end

    def hash
      @hash ||= children.map { |child| child.hash }.hash
    end
  end
end
