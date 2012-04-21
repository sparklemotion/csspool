module CSSPool
  module Visitors
    class ToCSS < Visitor

      CSS_IDENTIFIER_ILLEGAL_CHARACTERS =
        (0..255).to_a.pack('U*').gsub(/[a-zA-Z0-9_-]/, '')
      CSS_STRING_ESCAPE_MAP = {
        "\\" => "\\\\",
        "\"" => "\\\"",
        "\n" => "\\a ", # CSS2 4.1.3 p3.2
        "\r" => "\\\r",
        "\f" => "\\\f"
      }

      def initialize
        @indent_level = 0
        @indent_space = indent_space
      end

      visitor_for CSS::Document do |target|
        # Default media list is []
        current_media_type = []

        tokens = []

        target.charsets.each do |char_set|
          tokens << char_set.accept(self)
        end

        target.import_rules.each do |ir|
          tokens << ir.accept(self)
        end

        target.rule_sets.each { |rs|
          if rs.media != current_media_type
            media = " " + rs.media.map do |medium|
              escape_css_identifier medium.name.value
            end.join(', ')
            tokens << "#{indent}@media#{media} {"
            @indent_level += 1
          end

          tokens << rs.accept(self)

          if rs.media != current_media_type
            current_media_type = rs.media
            @indent_level -= 1
            tokens << "#{indent}}"
          end
        }
        tokens.join(line_break)
      end

      visitor_for CSS::Charset do |target|
        "@charset \"#{escape_css_string target.name}\";"
      end

      visitor_for CSS::ImportRule do |target|
        media = ''
        media = " " + target.media.map do |medium|
          escape_css_identifier medium.name.value
        end.join(', ') if target.media.length > 0

        "#{indent}@import #{target.uri.accept(self)}#{media};"
      end

      visitor_for CSS::RuleSet do |target|
        "#{indent}" +
          target.selectors.map { |sel| sel.accept self }.join(", ") + " {#{line_break}" +
          target.declarations.map { |decl| decl.accept self }.join(line_break) +
          "#{line_break}#{indent}}"
      end

      visitor_for CSS::Declaration do |target|
        important = target.important? ? ' !important' : ''

        indent {
          "#{indent}#{escape_css_identifier target.property}: " + target.expressions.map { |exp|

            op = '/' == exp.operator ? ' /' : exp.operator

            [
              op,
              exp.accept(self),
            ].join ' '
          }.join.strip + "#{important};"
        }
      end

      visitor_for Terms::Ident do |target|
        escape_css_identifier target.value
      end

      visitor_for Terms::Hash do |target|
        "##{target.value}"
      end

      visitor_for Selectors::Simple, Selectors::Universal do |target|
        ([target.name] + target.additional_selectors.map { |x|
          x.accept self
        }).join
      end

      visitor_for Terms::URI do |target|
        "url(\"#{escape_css_string target.value}\")"
      end

      visitor_for Terms::Function do |target|
        "#{escape_css_identifier target.name}(" +
          target.params.map { |x|
            [
              x.operator,
              x.accept(self)
            ].compact.join(' ')
          }.join + ')'
      end

      visitor_for Terms::Rgb do |target|
        params = [
          target.red,
          target.green,
          target.blue
        ].map { |c|
          c.accept(self)
        }.join ', '

        %{rgb(#{params})}
      end

      visitor_for Terms::String do |target|
        "\"#{escape_css_string target.value}\""
      end

      visitor_for Selector do |target|
        target.simple_selectors.map { |ss| ss.accept self }.join
      end

      visitor_for Selectors::Type do |target|
        combo = {
          :s => ' ',
          :+ => ' + ',
          :> => ' > '
        }[target.combinator]

        name = target.name == '*' ? '*' : escape_css_identifier(target.name)
        [combo, name].compact.join +
          target.additional_selectors.map { |as| as.accept self }.join
      end

      visitor_for Terms::Number do |target|
        [
          target.unary_operator == :minus ? '-' : nil,
          target.value,
          target.type
        ].compact.join
      end

      visitor_for Selectors::Id do |target|
        "##{escape_css_identifier target.name}"
      end

      visitor_for Selectors::Class do |target|
        ".#{escape_css_identifier target.name}"
      end

      visitor_for Selectors::PseudoClass do |target|
        if target.extra.nil?
          ":#{escape_css_identifier target.name}"
        else
          ":#{escape_css_identifier target.name}(#{escape_css_identifier target.extra})"
        end
      end

      visitor_for Selectors::PseudoElement do |target|
        if target.css2.nil?
          "::#{escape_css_identifier target.name}"
        else
          ":#{escape_css_identifier target.name}"
        end
      end

      visitor_for Selectors::Attribute do |target|
        case target.match_way
        when Selectors::Attribute::SET
          "[#{escape_css_identifier target.name}]"
        when Selectors::Attribute::EQUALS
          "[#{escape_css_identifier target.name}=\"#{escape_css_string target.value}\"]"
        when Selectors::Attribute::INCLUDES
          "[#{escape_css_identifier target.name} ~= \"#{escape_css_string target.value}\"]"
        when Selectors::Attribute::DASHMATCH
          "[#{escape_css_identifier target.name} |= \"#{escape_css_string target.value}\"]"
        else
          raise "no matching matchway"
        end
      end

      private
      def indent
        if block_given?
          @indent_level += 1
          result = yield
          @indent_level -= 1
          return result
        end
        "#{@indent_space * @indent_level}"
      end

      def line_break
        "\n"
      end

      def indent_space
        '  '
      end

      def escape_css_identifier text
        # CSS2 4.1.3 p2
        unsafe_chars = /[#{Regexp.escape CSS_IDENTIFIER_ILLEGAL_CHARACTERS}]/
        text.gsub(/^\d|^\-(?=\-|\d)|#{unsafe_chars}/um) do |char|
          if ':()-\\ ='.include? char
            "\\#{char}"
          else # I don't trust others to handle space termination well.
            "\\#{char.unpack('U').first.to_s(16).rjust(6, '0')}"
          end
        end
      end

      def escape_css_string text
        text.gsub(/[\\"\n\r\f]/) {CSS_STRING_ESCAPE_MAP[$&]}
      end
    end

    class ToMinifiedCSS < ToCSS
      def line_break
        ""
      end

      def indent_space
        ' '
      end

      visitor_for CSS::RuleSet do |target|
          target.selectors.map { |sel| sel.accept self }.join(", ") + " {" +
          target.declarations.map { |decl| decl.accept self }.join +
          " }"
      end
    end
  end
end
