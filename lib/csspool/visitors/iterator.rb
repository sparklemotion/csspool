module CSSPool
  module Visitors
    class Iterator < Visitor
      def initialize block
        @block = block
      end

      visitor_for CSS::Document do |target|
        [:charsets, :import_rules, :rule_sets].each do |member|
          target.send(member).each do |node|
            node.accept self
          end
        end
        @block.call target
      end

      visitor_for CSS::Charset do |target|
        @block.call target
      end

      visitor_for CSS::ImportRule do |target|
        target.media.each do |node|
          node.accept self
        end
        @block.call target
      end

      visitor_for CSS::Media,
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
        @block.call target
      end

      visitor_for CSS::Declaration do |target|
        target.expressions.each do |node|
          node.accept self
        end
        @block.call target
      end

      visitor_for CSS::RuleSet do |target|
        target.selectors.each do |node|
          node.accept self
        end
        target.declarations.each do |node|
          node.accept self
        end
        @block.call target
      end

      visitor_for Selector do |target|
        target.simple_selectors.each { |ss| ss.accept self }
        @block.call target
      end

      visitor_for Selectors::Type do |target|
        target.additional_selectors.each do |node|
          node.accept self
        end
        @block.call target
      end
    end
  end
end
