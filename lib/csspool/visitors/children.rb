module CSSPool
  module Visitors
    class Children < Visitor
      visitor_for CSS::Document do |target|
        children = []
        [:charsets, :import_rules, :rule_sets].each do |member|
          children += target.send(member)
        end
        children
      end

      visitor_for CSS::ImportRule do |target|
        target.media
      end

      visitor_for CSS::Media,
        CSS::Charset,
        Selectors::Id,
        Selectors::Class,
        Selectors::PseudoClass,
        Selectors::Attribute,
        Terms::Ident,
        Terms::String,
        Terms::URI,
        Terms::Number,
        Terms::Hash,
        Terms::Function,
        Terms::Rgb do |target|
        []
      end

      visitor_for CSS::Declaration do |target|
        target.expressions
      end

      visitor_for CSS::RuleSet do |target|
        target.selectors + target.declarations
      end

      visitor_for Selector do |target|
        target.simple_selectors
      end

      visitor_for Selectors::Type do |target|
        target.additional_selectors
      end
    end
  end
end

