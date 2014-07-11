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
        [:selectors, :declarations, :parent_rule].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for Selector do |target|
        target.simple_selectors == @other.simple_selectors
      end

      visitor_for CSS::ImportRule do |target|
        [:uri, :namespace, :media_list].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for Selectors::PseudoClass do |target|
        [:name, :extra].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for CSS::MediaType, Selectors::Id, Selectors::Class do |target|
        target.name == @other.name
      end

      visitor_for Selectors::Type, Selectors::Universal,
        Selectors::Simple do |target|
        [:name, :combinator, :additional_selectors].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for CSS::Declaration do |target|
        [:property, :expressions, :important].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for CSS::MediaFeature do |target|
        [:property, :value].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for CSS::MediaQuery do |target|
        [:only_or_not, :media_expr, :and_exprs].all? { |m|
          target.send(m) == @other.send(m)
        }
      end

      visitor_for CSS::MediaQueryList do |target|
        [:media_queries].all? { |m|
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
          :operator
        ].all? { |m| target.send(m) == @other.send(m) }
      end

      visitor_for Terms::Resolution do |target|
        [
          :number,
          :unit
        ].all? { |m| target.send(m) == @other.send(m) }
      end
    end
  end
end
