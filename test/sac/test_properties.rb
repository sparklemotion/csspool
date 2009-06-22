require 'helper'

module Crocodile
  module SAC
    class TestProperties < Crocodile::TestCase
      def setup
        super
        @doc = MyDoc.new
        @css = <<-eocss
          @charset "UTF-8";
          @import url("foo.css") screen;
          /* This is a comment */
          div a.foo, #bar, * { background: red; }
          div#a, a.foo, a:hover, a[href][int="10"]{ background: red; }
        eocss
        @parser = Crocodile::SAC::Parser.new(@doc)
        @parser.parse(@css)
      end

      def test_properties
        assert_equal ['background'], @doc.properties.map { |x| x.first }.uniq
        @doc.properties.each do |property|
          assert_equal 1, property[1].length
        end
        assert_equal ['red'], @doc.properties.map { |x| x[1].first.value }.uniq
      end

      def test_ident_with_comma
        doc = MyDoc.new
        parser = Crocodile::SAC::Parser.new(doc)
        parser.parse <<-eocss
          h1 { font-family: Verdana, sans-serif, monospace; }
        eocss
        assert_equal 1, doc.properties.length
        values = doc.properties.first[1]
        assert_equal 3, values.length
        assert_equal [nil, :comma, :comma],
          values.map { |value| value.operator }
        values.each { |value| assert value.parse_location }
      end

      def test_negative_number
        doc = MyDoc.new
        parser = Crocodile::SAC::Parser.new(doc)
        parser.parse <<-eocss
          div { border: -1px; }
        eocss
        assert_equal 1, doc.properties.length
        size = doc.properties.first[1].first
        assert_equal :minus, size.operator
        assert_equal 1, size.value
        assert_equal '-1.0px', size.to_s
      end

      def test_positive_number
        doc = MyDoc.new
        parser = Crocodile::SAC::Parser.new(doc)
        parser.parse <<-eocss
          div { border: 1px; }
        eocss
        assert_equal 1, doc.properties.length
        size = doc.properties.first[1].first
        assert_equal 1, size.value
        assert_equal '1.0px', size.to_s
      end

      %w{
        1 1em 1ex 1px 1in 1cm 1mm 1pt 1pc 1% 1deg 1rad 1ms 1s 1Hz 1kHz
      }.each do |num|
        expected = num.sub(/1/, '1.0')
        define_method(:"test_num_#{num}") do
          doc = MyDoc.new
          parser = Crocodile::SAC::Parser.new(doc)
          parser.parse <<-eocss
            div { border: #{num}; }
          eocss
          assert_equal 1, doc.properties.length
          size = doc.properties.first[1].first
          assert_equal 1, size.value
          assert_equal expected, size.to_s
        end
      end
    end
  end
end
