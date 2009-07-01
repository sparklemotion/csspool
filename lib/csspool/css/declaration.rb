module CSSPool
  module CSS
    class Declaration < Struct.new(:property, :expressions, :important, :rule_set)
      include CSSPool::Visitable
      alias :important? :important
    end
  end
end
