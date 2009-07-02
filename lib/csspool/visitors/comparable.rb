module CSSPool
  module Visitors
    class Comparable < Visitor
      def initialize other
        super()
        @other = other
      end

      visitor_for CSS::Document do |target|
        [
          :parent,
          :charsets,
          :parent_import_rule,
          :import_rules,
          :rule_sets,
        ].all? { |m| target.send(m) == @other.send(m) }
      end

      visitor_for CSS::RuleSet do |target|
        [:selectors, :declarations, :media].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for Selector do |target|
        target.simple_selectors == @other.simple_selectors
      end

      visitor_for CSS::ImportRule do |target|
        [:uri, :namespace, :media].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for CSS::Media do |target|
        target.name == @other.name
      end

      visitor_for Selectors::Type do |target|
        [:name, :combinator, :additional_selectors].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for CSS::Declaration do |target|
        [:property, :expressions, :important].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for Terms::Function do |target|
        [:name, :params, :operator].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for Terms::Number do |target|
        [:type, :unary_operator, :value, :operator].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for Terms::URI,Terms::String,Terms::Ident,Terms::Hash do |target|
        [:value, :operator].all? { |m| target.send(m) == @other.send(m) }
      end

      visitor_for Terms::Rgb do |target|
        [
          :red,
          :green,
          :blue,
          :percentage,
          :operator
        ].all? { |m| target.send(m) == @other.send(m) }
      end
    end
  end
end
