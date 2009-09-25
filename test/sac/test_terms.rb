require 'helper'

module CSSPool
  module SAC
    class TestTerms < CSSPool::TestCase
      def setup
        @doc = MyDoc.new
        @parser = CSSPool::SAC::Parser.new(@doc)
      end

      def test_hash_range
        @parser.parse <<-eocss
          div { border: #123; }
        eocss
        hash = @doc.properties.first[1].first
        assert_equal '123', hash.value
      end

      def test_rgb
        @parser.parse <<-eocss
          div { border: rgb(1,2,3); }
        eocss
        color = @doc.properties.first[1].first
        assert_equal 1, color.red
        assert_equal 2, color.green
        assert_equal 3, color.blue
        assert !color.percentage?
        assert_match('rgb(1,2,3)', color.to_css)
      end

      def test_rgb_with_percentage
        @parser.parse <<-eocss
          div { border: rgb(100%,2%,3%); }
        eocss
        color = @doc.properties.first[1].first
        assert_equal 100, color.red
        assert_equal 2, color.green
        assert_equal 3, color.blue
        assert color.percentage?
        assert_match('rgb(100%,2%,3%)', color.to_css)
      end

      def test_negative_number
        @parser.parse <<-eocss
          div { border: -1px; }
        eocss
        assert_equal 1, @doc.properties.length
        size = @doc.properties.first[1].first
        assert_equal :minus, size.unary_operator
        assert_equal 1, size.value
        assert_equal '-1px', size.to_s
        assert_equal '-1px', size.to_css
      end

      def test_positive_number
        @parser.parse <<-eocss
          div { border: 1px; }
        eocss
        assert_equal 1, @doc.properties.length
        size = @doc.properties.first[1].first
        assert_equal 1, size.value
        assert_equal '1px', size.to_s
      end

      %w{
        1 1em 1ex 1px 1in 1cm 1mm 1pt 1pc 1% 1deg 1rad 1ms 1s 1Hz 1kHz
      }.each do |num|
        define_method(:"test_num_#{num}") do
          @parser.parse <<-eocss
            div { border: #{num}; }
          eocss
          assert_equal 1, @doc.properties.length
          size = @doc.properties.first[1].first
          assert_equal 1, size.value
          assert_equal num, size.to_s
          assert_equal num, size.to_css
        end
      end

      def test_string_term
        @parser.parse <<-eocss
          div { border: "hello"; }
        eocss
        assert_equal 1, @doc.properties.length
        string = @doc.properties.first[1].first
        assert_equal 'hello', string.value
        assert_equal '"hello"', string.to_css
      end

      def test_inherit
        @parser.parse <<-eocss
          div { color: inherit; }
        eocss
        assert_equal 1, @doc.properties.length
        string = @doc.properties.first[1].first
        assert_equal 'inherit', string.value
        assert_equal 'inherit', string.to_css
      end

      def test_important
        @parser.parse <<-eocss
          div { color: inherit !important; }
        eocss
        assert_equal 1, @doc.properties.length
        string = @doc.properties.first[1].first
        assert_equal 'inherit', string.value
        assert_equal 'inherit', string.to_css
      end

      def test_function
        @parser.parse <<-eocss
          div { border: foo("hello"); }
        eocss
        assert_equal 1, @doc.properties.length
        func = @doc.properties.first[1].first
        assert_equal 'foo', func.name
        assert_equal 1, func.params.length
        assert_equal 'hello', func.params.first.value
        assert_match 'foo("hello")', func.to_css
      end

      def test_uri
        @parser.parse <<-eocss
          div { border: url(http://tenderlovemaking.com/); }
        eocss
        assert_equal 1, @doc.properties.length
        url = @doc.properties.first[1].first
        assert_equal 'http://tenderlovemaking.com/', url.value
        assert_match 'url(http://tenderlovemaking.com/)', url.to_css
      end
    end
  end
end
