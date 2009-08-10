require 'helper'

module CSSPool
  module Visitors
    class TestEach < CSSPool::TestCase
      def test_iterate
        doc = CSSPool.CSS <<-eocss
          @charset "UTF-8";
          @import url("foo.css") screen;
          div#a, a.foo, a:hover, a[href][int="10"]{ background: red; }
        eocss
        list = []
        doc.each { |node| list << node }
        assert_equal 20, list.length
        assert list.hash
      end
    end
  end
end
