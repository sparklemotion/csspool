module CSS
  module SAC
    module Visitable # :nodoc:
      # Based off the visitor pattern from RubyGarden
      def accept(visitor, &block)
        klass = self.class.ancestors.find { |klass|
          visitor.respond_to?("visit_#{klass.name.split(/::/)[-1]}")
        }

        if klass
          visitor.send(:"visit_#{klass.name.split(/::/)[-1]}", self, &block)
        else
          raise "No visitor for '#{self.class}'"
        end
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
        return false unless visit_SimpleSelector(o) # *sigh*
        o.name == @node.name
      end

      def visit_ChildSelector(o)
        return false unless visit_SimpleSelector(o) # *sigh*
        return false unless @node.respond_to?(:parent)
        return false if @node.parent.nil?
        return false unless o.selector.accept(self)
        @node = @node.parent
        o.parent.accept(self)
      end

      def visit_DescendantSelector(o)
        return false unless visit_SimpleSelector(o) # *sigh*
        return false unless @node.respond_to?(:parent)
        return false if @node.parent.nil?
        return false unless o.selector.accept(self)

        @node = @node.parent
        loop {
          return true if o.ancestor.accept(self)
          return false unless @node.respond_to?(:parent)
          @node = @node.parent
        }
      end

      def visit_SiblingSelector(o)
        return false unless visit_SimpleSelector(o) # *sigh*
        return false unless @node.respond_to?(:next_sibling)
        return false if @node.next_sibling.nil?
        return false unless o.selector.accept(self)
        @node = @node.next_sibling
        o.sibling.accept(self)
      end

      def visit_ConditionalSelector(o)
        return false unless visit_SimpleSelector(o) # *sigh*
        [o.selector, o.condition].compact.all? { |x|
          x.accept(self)
        }
      end

      def visit_AttributeCondition(o)
        return false unless @node.respond_to?(:attributes)
        return false unless @node.attributes[o.local_name]
        @node.attributes[o.local_name] == o.value
      end

      def visit_BeginHyphenCondition(o)
        return false unless @node.respond_to?(:attributes)
        return false unless @node.attributes[o.local_name]
        @node.attributes[o.local_name] =~ /^#{o.value}/
      end

      def visit_CombinatorCondition(o)
        o.first.accept(self) && o.second.accept(self)
      end

      def visit_OneOfCondition(o)
        return false unless @node.respond_to?(:attributes)
        return false unless @node.attributes[o.local_name]
        @node.attributes[o.local_name].split.any? { |attribute|
          attribute == o.value
        }
      end

      def visit_PseudoClassCondition(o)
        false # Fuck pseudo classes.  --Aaron
      end
    end
  end
end
