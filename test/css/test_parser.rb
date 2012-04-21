# -*- coding: utf-8 -*-

require "helper"

module CSSPool
  module CSS
    class TestParser < CSSPool::TestCase
      class MethodCatcher
        attr_reader :calls

        def initialize
          @calls = []
        end

        def method_missing name, *args
          @calls << [name, args]
        end
      end

      def setup
        super
        @doc = MethodCatcher.new
        @parser = Class.new(CSSPool::CSS::Tokenizer) {
          attr_accessor :handler
          def initialize doc
            @handler = doc
          end
        }.new(@doc)
      end

      {
        'em'  => 'em',
        'per' => '%',
        'ex'  => 'ex',
        'ex'  => 'ex',
        'deg' => 'deg',
        'ms'  => 'ms',
        'hz'  => 'hz',
      }.each do |type, s|
        define_method(:"test_term_#{type}") do
          assert_term({
            :class  => Terms::Number,
            :value  => 10,
            :type   => s
          }, "div { foo: 10#{s}; }")
        end
      end

      def test_term_rgb
        assert_term({
          :class  => Terms::Rgb,
        }, "div { foo: rgb(255, 255, 255); }")
      end

      def test_term_function
        assert_term({
          :class  => Terms::Function,
          :name   => "foo",
        }, "div { foo: foo(bar); }")
        assert_term({
          :class  => Terms::Function,
          :name   => "foo",
        }, "div { foo: foo(bar) baz; }")
      end

      def test_term_hexcolor
        assert_term({
          :class  => Terms::Hash,
          :value  => "666",
        }, "div { foo: #666; }")
        assert_term({
          :class  => Terms::Hash,
          :value  => "666",
        }, "div { foo: #666 foo; }")
      end

      def test_term_string
        assert_term({
          :class  => Terms::String,
          :value  => "foo",
        }, "div { foo: 'foo'; }")
        assert_term({
          :class  => Terms::String,
          :value  => "foo",
        }, "div { foo: 'foo'   ; }")
        assert_term({
          :class  => Terms::String,
          :value  => "foo",
        }, "div { foo: 'foo'  bar; }")
      end

      def test_term_uri
        assert_term({
          :class  => Terms::URI,
          :value  => "http://example.com/",
        }, "div { foo: url(http://example.com/); }")
        assert_term({
          :class  => Terms::URI,
          :value  => "http://example.com/",
        }, "div { foo: url(http://example.com/) bar; }")
      end

      def test_term_length
        assert_term({
          :class  => Terms::Number,
          :value  => 10,
          :type   => 'mm'
        }, 'div { foo: 10mm; }')
        assert_term({
          :class  => Terms::Number,
          :value  => 1.2,
          :type   => 'mm'
        }, 'div { foo: 1.2mm; }')
        assert_term({
          :class  => Terms::Number,
          :value  => 1.2,
          :type   => 'mm'
        }, 'div { foo: 1.2mm; }')
      end

      def test_term_number
        assert_term({ :class => Terms::Number, :value => 1.2 }, 'div { foo: 1.2; }')
        assert_term({ :class => Terms::Number, :value => 10 }, 'div { foo: 10; }')
        assert_term({ :class => Terms::Number, :unary_operator => :minus },
                    'div { foo: -10; }')
        assert_term({ :class => Terms::Number, :unary_operator => :plus },
                    'div { foo: +10; }')
      end

      def assert_term term, css
        @parser.handler = MethodCatcher.new
        @parser.scan_str css
        property = @parser.handler.calls.find { |x|
          x.first == :property
        }[1][1].first

        term.each do |k,v|
          assert_equal v, property.send(k)
        end
      end

      def test_element_op
        assert_decl 'background',
                    %w{red green},
                    'div { background: red, green; }',
                    [nil, ',']
        assert_decl 'background',
                    %w{red green},
                    'div { background: red / green; }',
                    [nil, '/']
      end

      def test_declaration_ident
        assert_decl 'background', ['red'], 'div { background: red; }'
        assert_decl 'background', %w{red green},'div { background: red green; }'
      end

      def test_multi_decl
        @parser.scan_str 'div { background: red; padding: 0; }'
        names = @parser.handler.calls.find_all { |x|
          x.first == :property
        }.map { |y| y[1].first }
        assert_equal %w{ background padding }, names
      end

      def test_ie_safe_hack
        # http://mathiasbynens.be/notes/safe-css-hacks
        @parser.scan_str <<-eocss
          .foo {
            color: black;
            color: green\\9; /* IE8 and older, but there's more... */
            *color: blue; /* IE7 and older */
            _color: red; /* IE6 and older */
          }
        eocss
        declarations = @parser.handler.calls.find_all { |x|
          x.first == :property
        }
        names = declarations.map { |y| y[1].first }
        assert_equal %w{color color *color _color}, names
        # values = declarations.map { |y| y[1][1].first.to_s }
        # assert_equal %w{black green\\9 blue red}, values
      end

      def test_star_attribute
        assert_attribute '*:foo { }'
        assert_attribute 'a *.foo { }'
        assert_attribute 'a * bar { }'
      end

      def test_ruleset_div_attribute_recurses
        assert_attribute 'div[a]:foo { }'
        assert_attribute 'div:foo[a] { }'
        assert_attribute 'div#foo[a] { }'
        assert_attribute 'div.foo[a] { }'
        assert_attribute 'div[a]::foo { }'
      end

      def test_additional_selectors_id_pesuedoclass
        assert_additional_selector(
          [
            [ Selectors::Id, 'foo' ],
            [ Selectors::PseudoClass, 'foo' ]
          ], '#foo:foo { }')
      end

      def test_additional_selectors_class_pesuedoclass
        assert_additional_selector(
          [
            [ Selectors::Class, 'foo' ],
            [ Selectors::PseudoClass, 'foo' ]
          ], '.foo:foo { }')
      end

      def test_additional_selectors_attribute_pesuedoclass
        assert_additional_selector(
          [
            [ Selectors::Attribute, 'foo' ],
            [ Selectors::PseudoClass, 'foo' ]
          ], '[foo]:foo { }')
      end

      def test_additional_selectors_pseudo_class
        assert_additional_selector(
          [
            [ Selectors::PseudoClass, 'foo' ],
            [ Selectors::Class, 'foo' ]
          ], ':foo.foo { }')
      end

      def test_additional_selectors_attribute
        assert_additional_selector(
          { Selectors::Attribute => 'foo' }, '[foo] { }')
        assert_additional_selector(
          { Selectors::Attribute => 'foo' }, '[foo |= "bar"] { }')
        assert_additional_selector(
          { Selectors::Attribute => 'foo' }, '[foo |= bar] { }')
        assert_additional_selector(
          { Selectors::Attribute => 'foo' }, '[foo ~= bar] { }')
        assert_additional_selector(
          { Selectors::Attribute => 'foo' }, '[foo ~= "bar"] { }')
        assert_additional_selector(
          { Selectors::Attribute => 'foo' }, '[foo = "bar"] { }')
        assert_additional_selector(
          { Selectors::Attribute => 'foo' }, '[foo = bar] { }')
      end

      def test_additional_selectors_pseudo
        assert_additional_selector(
          { Selectors::PseudoClass => 'foo' }, ':foo { }')
        assert_additional_selector(
          { Selectors::PseudoClass => 'foo' }, ':foo() { }')
        assert_additional_selector(
          { Selectors::PseudoClass => 'foo' }, ':foo(a) { }')
        assert_additional_selector(
          { Selectors::PseudoElement => 'foo' }, '::foo { }')
        assert_additional_selector(
          { Selectors::PseudoElement => 'before' }, ':before { }')
      end

      def test_additional_selectors_id
        assert_additional_selector({ Selectors::Id => 'foo' }, '#foo { }')
      end

      def test_additional_selectors_class
        assert_additional_selector({ Selectors::Class => 'foo' }, '.foo { }')
      end

      def test_ruleset_multiple_selectors
        assert_attribute '.foo, bar, #baz { }'
        sels = args_for(:start_selector).first
        assert_equal 3, sels.length
        sels.each do |sel|
          assert_instance_of Selector, sel
        end
      end

      def test_ruleset_class_no_name
        assert_attribute '.foo { }'
      end

      def test_ruleset_id_no_name
        assert_attribute 'foo { }'
      end

      def test_ruleset_div_pseudo_function_with_arg
        assert_attribute 'div:foo.bar(bar) { }'
      end

      def test_ruleset_div_pseudo_function
        assert_attribute 'div:foo() { }'
      end

      def test_ruleset_div_pseudo
        assert_attribute 'div:foo { }'
      end

      def test_ruleset_div_attribute_dashmatch_string
        assert_attribute 'div[a |= "b"] { }'
      end

      def test_ruleset_div_attribute_dashmatch_ident
        assert_attribute 'div[a |= b] { }'
      end

      def test_ruleset_div_attribute_includes_ident
        assert_attribute 'div[a ~= b] { }'
      end

      def test_ruleset_div_attribute_includes_string
        assert_attribute 'div[a ~= "b"] { }'
      end

      def test_ruleset_div_attribute_equals_string
        assert_attribute 'div[a = "b"] { }'
      end

      def test_ruleset_div_attribute_equals_ident
        assert_attribute 'div[a = b] { }'
      end

      def test_ruleset_div_attribute_exists
        assert_attribute 'div[a] { }'
      end

      def test_ruleset_div_class
        assert_attribute 'div.foo { }'
      end

      def test_ruleset_div_hash
        assert_attribute 'div#foo { }'
      end

      def test_ruleset_div
        assert_attribute 'div { }'
      end

      def test_ruleset_star
        assert_attribute '* { }'
      end

      {
        ' '   => :s,
        ' > ' => :>,
        ' + ' => :+
      }.each do |combo, sym|
        define_method(:"test_combo_#{sym}") do
          assert_attribute "div #{combo} p  a { }"

          sel = args_for(:start_selector).first.first
          assert_equal 3, sel.simple_selectors.length
          assert_equal [nil, sym, :s],
            sel.simple_selectors.map { |x| x.combinator }
        end
      end

      def test_import
        @parser.scan_str '@import "foo";'
        assert_equal 'foo', doc.calls[1][1][1].value
        assert_equal :import_style, doc.calls[1].first
      end

      def test_missing_semicolon
        @parser.scan_str 'div { border: none }'
        assert_equal 'div', doc.calls[1][1][0].join
        assert_equal 'border', doc.calls[2][1][0]
        assert_equal 'none', doc.calls[2][1][1].join
      end

      def test_whitespaces
        @parser.scan_str 'div { border : none }'
        assert_equal 'div', doc.calls[1][1][0].join
        assert_equal 'border', doc.calls[2][1][0]
        assert_equal 'none', doc.calls[2][1][1].join
      end

      def test_import_medium
        @parser.scan_str '@import "foo" page;'
        assert_equal :import_style, doc.calls[1].first
        assert_equal 'foo', doc.calls[1][1][1].value
        assert_equal 'page', doc.calls[1][1].first.first.value
      end

      def test_import_medium_multi
        @parser.scan_str '@import "foo" page, print;'
        assert_equal :import_style, doc.calls[1].first
        assert_equal 'foo', doc.calls[1][1][1].value
        assert_equal 'page', doc.calls[1][1].first.first.value
        assert_equal 'print', doc.calls[1][1].first[1].value
      end

      def test_start_stop
        @parser.scan_str "@import 'foo';"
        assert_equal [:start_document, []], @doc.calls.first
        assert_equal [:end_document, []], @doc.calls.last
      end

      def test_charset
        @parser.scan_str '@charset "UTF-8";'
        assert_equal [:charset, ['UTF-8', {}]], @doc.calls[1]
      end

      def assert_attribute css
        @parser.handler = MethodCatcher.new
        @parser.scan_str css
        assert_equal :start_selector, @parser.handler.calls[1].first
        assert_equal :end_selector, @parser.handler.calls[2].first
      end

      def assert_decl name, values, css, ops = nil
        @parser.handler = MethodCatcher.new
        @parser.scan_str css
        assert_equal :start_selector, @parser.handler.calls[1].first
        assert_equal :property, @parser.handler.calls[2].first
        assert_equal :end_selector, @parser.handler.calls[3].first

        property = @parser.handler.calls[2][1]
        assert_equal name, property.first

        assert_equal values, property[1].map { |x| x.value }
        if ops
          assert_equal ops, property[1].map { |x| x.operator }
        end
      end

      def doc; @parser.handler end
      def args_for s; doc.calls.find { |x| x.first == s }[1] end

      def assert_additional_selector things, css
        @parser.handler = MethodCatcher.new
        @parser.scan_str css
        args = @parser.handler.calls.find { |x|
          x.first == :start_selector
        }[1]

        ss = args.first.first.simple_selectors.first

        assert_equal things.length, ss.additional_selectors.length
        i = 0
        things.each do |klass, name|
          assert_instance_of klass, ss.additional_selectors[i]
          assert_equal name, ss.additional_selectors[i].name
          i += 1
        end
      end

    end
  end
end
