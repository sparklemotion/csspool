module Crocodile
  module Visitors
    class ToCSS < Visitor
      visitor_for CSS::Document do |target|
        target.rule_sets.map { |rs| rs.accept self }.join("\n")
      end

      visitor_for CSS::RuleSet do |target|
        target.selectors.map { |sel| sel.accept self }.join(", ") + " {\n" +
          target.declarations.map { |decl| decl.accept self }.join("\n") + "\n}\n"
      end

      visitor_for CSS::Declaration do |target|
        "  #{target.property}: " + target.expressions.map { |exp|
          exp.accept self
        }.join + ";"
      end

      visitor_for Terms::Ident do |target|
        [target.operator, target.value].compact.join(' ')
      end

      visitor_for Terms::Hash do |target|
        "##{target.value}"
      end

      visitor_for Terms::URI do |target|
        "url(#{target.value})"
      end

      visitor_for Terms::Function do |target|
        "#{target.name}(" +
          target.params.map { |x| x.accept self }.join(', ') +
          ')'
      end

      visitor_for Terms::Rgb do |target|
        params = [
          target.red,
          target.green,
          target.blue
        ].map { |c| target.percentage? ? "#{c}%" : c }.join(',')

        %{rgb(#{params})}
      end

      visitor_for Terms::String do |target|
        "\"#{target.value}\""
      end

      visitor_for Selector do |target|
        target.simple_selectors.map { |ss| ss.accept self }.join
      end

      visitor_for Selectors::Type do |target|
        combo = {
          0 => nil,
          1 => ' ',
          2 => ' + ',
          3 => ' > '
        }[target.combinator]

        [combo, target.name].compact.join +
          target.additional_selectors.map { |as| as.accept self }.join
      end

      visitor_for Terms::Number do |target|
        units = {
          2   => 'em',
          3   => 'ex',
          4   => 'px',
          5   => 'in',
          6   => 'cm',
          7   => 'mm',
          8   => 'pt',
          9   => 'pc',
          10  => 'deg',
          11  => 'rad',
          12  => 'grad',
          13  => 'ms',
          14  => 's',
          15  => 'Hz',
          16  => 'kHz',
          17  => '%',
        }[target.type]
        [
          target.operator == :minus ? '-' : nil,
          target.value,
          units
        ].compact.join
      end

      visitor_for Selectors::Id do |target|
        "##{target.name}"
      end

      visitor_for Selectors::Class do |target|
        ".#{target.name}"
      end

      visitor_for Selectors::PseudoClass do |target|
        ":#{target.name}"
      end

      visitor_for Selectors::Attribute do |target|
        case target.match_way
        when Selectors::Attribute::NO_MATCH
        when Selectors::Attribute::SET
          "[#{target.name}]"
        when Selectors::Attribute::EQUALS
          "[#{target.name}=\"#{target.value}\"]"
        when Selectors::Attribute::INCLUDES
        when Selectors::Attribute::DASHMATCH
        else
          raise "no matching matchway"
        end
      end
    end
  end
end
