module CSSPool
  class Node
    include Enumerable
    
    # These give the position of this node in the source CSS. Not all
    # node types are supported. "Outer" represents the start/end of
    # this node, "inner" represents the start/end of this node's
    # children. Outer will not contain leading or trailing comments or
    # whitespace, while inner will. For example, in this code:
    #
    # ---
    # 1 /* test1 */
    # 2 @document domain('example.com') {
    # 3 	/* test2 */
    # 4 	* { color: blue; }
    # 5 	/* test3 */
    # 6 } /* test4 */
    # ---
    # 
    # The index will represent the position:
    # outer_start_pos: 2:0
    # inner_start_pos: 2:33
    # inner_end_pos: 6:0
    # outer_end_pos: 6:1
    attr_accessor :outer_start_pos, :inner_start_pos, :inner_end_pos, :outer_end_pos

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
