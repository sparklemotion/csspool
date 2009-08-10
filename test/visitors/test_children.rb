require 'helper'

module CSSPool
  module Visitors
    class TestChildren < CSSPool::TestCase
      def test_iterate
        doc = CSSPool.CSS <<-eocss
          @charset "UTF-8";
          @import url("foo.css") screen;
          div#a, a.foo, a:hover, a[href][int="10"]{ background: red; }
        eocss

        stack = [doc]
        until stack.empty? do
          stack += stack.pop.children
        end
      end
    end
  end
end
