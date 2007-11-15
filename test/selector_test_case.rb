class SelectorTestCase < Test::Unit::TestCase
  include CSS::SAC::Selectors
  Node = Struct.new(:name, :parent, :child, :next_sibling)
  NoParentNode = Struct.new(:name)

  def parent_child_tree(*args)
    nodes = args.map { |name|
      n = Node.new
      n.name = name
      n
    }
    nodes.each_with_index do |n,i|
      n.child = nodes[i + 1] if i < nodes.length
      n.parent = nodes[i - 1] if i > 0
    end
    nodes.last
  end

  undef :default_test
end
