require 'helper'

module Crocodile
  module SAC
    class TestTerms < Crocodile::TestCase
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

      def test_string_term
        doc = MyDoc.new
        parser = Crocodile::SAC::Parser.new(doc)
        parser.parse <<-eocss
          div { border: "hello"; }
        eocss
        assert_equal 1, doc.properties.length
        string = doc.properties.first[1].first
        assert_equal 'hello', string.value
        assert_equal '"hello"', string.to_css
      end

      def test_function
        doc = MyDoc.new
        parser = Crocodile::SAC::Parser.new(doc)
        parser.parse <<-eocss
          div { border: foo("hello"); }
        eocss
        assert_equal 1, doc.properties.length
        func = doc.properties.first[1].first
        assert_equal 'foo', func.name
        assert_equal 1, func.params.length
        assert_equal 'hello', func.params.first.value
      end
    end
  end
end
