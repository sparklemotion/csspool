module CSS
  module Visitable # :nodoc:
    # Based off the visitor pattern from RubyGarden
    def accept(visitor, &block)
      self.class.ancestors.find_all { |klass|
        visitor.methods.include?("visit_#{klass.name.split(/::/)[-1]}")
      }.reverse.all? { |klass|
        visitor.send(:"visit_#{klass.name.split(/::/)[-1]}", self, &block)
      }
    end

    def Visitable.included(kls)
      kls.module_eval <<-"end_eval"
      def self.inherited(child)
        child.module_eval "include CSS::Visitable"
      end
      end_eval
    end
  end

  class MatchesVisitor
    def initialize(node)
      @node = node
    end

    def accept(target)
      target.accept(self)
    end

    def visit_SimpleSelector(o)
      return false if @node.nil?
      return false unless @node.respond_to?(:name)
      true
    end

    def visit_ElementSelector(o)
      o.name == @node.name
    end

    def visit_ChildSelector(o)
      return false unless @node.respond_to?(:parent)
      return false if @node.parent.nil?
      return false unless o.selector.accept(self)
      @node = @node.parent
      o.parent.accept(self)
    end

    def visit_DescendantSelector(o)
      return false unless @node.respond_to?(:parent)
      return false if @node.parent.nil?
      return false unless o.selector.accept(self)

      @node = @node.parent
      loop {
        return true if o.ancestor.accept(self)
        return false unless @node.respond_to?(:parent)
        @node = @node.parent
      }
      false
    end
  end
end
