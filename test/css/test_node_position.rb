require 'helper'

module CSSPool
  module CSS
    class TestNodePosition < CSSPool::TestCase

      def test_no_whitespace
        child_content = '* { color: blue !important }'
        css = "@document url(\"http://www.example.com\") {#{child_content}}"
        doc = CSSPool.CSS css
        assert_equal 1, doc.document_queries.size
        dq = doc.document_queries.first
        assert !dq.outer_start_pos.nil?
        assert !dq.inner_start_pos.nil?
        assert !dq.inner_end_pos.nil?
        assert !dq.outer_end_pos.nil?
        assert_equal css, css[dq.outer_start_pos..dq.outer_end_pos-1]
        assert_equal child_content, css[dq.inner_start_pos..dq.inner_end_pos-1]
      end

      def test_whitespace
        child_content = '  
            * { color: blue !important } 
        '
        css = "
          @document url(\"http://www.example.com\") {#{child_content}}
        "
        doc = CSSPool.CSS css
        assert_equal 1, doc.document_queries.size
        dq = doc.document_queries.first
        assert !dq.outer_start_pos.nil?
        assert !dq.inner_start_pos.nil?
        assert !dq.inner_end_pos.nil?
        assert !dq.outer_end_pos.nil?
        # the whitespace on the "outside" should not be included
        assert_equal css.strip, css[dq.outer_start_pos..dq.outer_end_pos-1]
        # the whitespace on the "inside" should be retained
        assert_equal child_content, css[dq.inner_start_pos..dq.inner_end_pos-1]
      end

      def test_comments
        child_content = '  /* comment two */ 
          * { color: blue !important } 
          /* comment three */
        '
        css = "  /* comment one */
          @document url(\"http://www.example.com\") {#{child_content}}
        /* comment four */
        "
        doc = CSSPool.CSS css
        assert_equal 1, doc.document_queries.size
        dq = doc.document_queries.first
        assert !dq.outer_start_pos.nil?
        assert !dq.inner_start_pos.nil?
        assert !dq.inner_end_pos.nil?
        assert !dq.outer_end_pos.nil?
        # the comments and whitespace to the "outside" should not be retained
        assert_equal css.sub('/* comment one */', '').sub('/* comment four */', '').strip, css[dq.outer_start_pos..dq.outer_end_pos-1]
        # the comments and whitespace on the "inside" should be retained
        assert_equal child_content, css[dq.inner_start_pos..dq.inner_end_pos-1]
      end

      # this only works in ruby 2+
      def test_multibyte_characters
        child_content = '/* â */ * { color: blue !important }'
        css = "@document url(\"http://www.example.com\") {#{child_content}}"
        doc = CSSPool.CSS css
        assert_equal 1, doc.document_queries.size
        dq = doc.document_queries.first
        assert !dq.outer_start_pos.nil?
        assert !dq.inner_start_pos.nil?
        assert !dq.inner_end_pos.nil?
        assert !dq.outer_end_pos.nil?
        assert_equal css, css[dq.outer_start_pos..dq.outer_end_pos-1]
        assert_equal child_content, css[dq.inner_start_pos..dq.inner_end_pos-1]
      end

    end
  end
end

