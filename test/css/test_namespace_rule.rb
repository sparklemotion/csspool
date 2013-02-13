require 'helper'

# CSS namespaces - http://www.w3.org/TR/css3-namespace/
module CSSPool
  module CSS
    class TestNamespaceRule < CSSPool::TestCase

      def test_default_string
        doc = CSSPool.CSS <<-eocss
          @namespace "http://www.w3.org/1999/xhtml/";
        eocss
        assert_equal 1, doc.namespaces.size
        assert_equal CSSPool::CSS::NamespaceRule, doc.namespaces[0].class
        assert_equal nil, doc.namespaces[0].prefix
        assert_equal CSSPool::Terms::String, doc.namespaces[0].uri.class
        assert_equal 'http://www.w3.org/1999/xhtml/', doc.namespaces[0].uri.value
      end

      def test_default_uri
        doc = CSSPool.CSS <<-eocss
          @namespace url("http://www.w3.org/1999/xhtml/");
        eocss
        assert_equal 1, doc.namespaces.size
        assert_equal CSSPool::CSS::NamespaceRule, doc.namespaces[0].class
        assert_equal nil, doc.namespaces[0].prefix
        assert_equal CSSPool::Terms::URI, doc.namespaces[0].uri.class
        assert_equal 'http://www.w3.org/1999/xhtml/', doc.namespaces[0].uri.value
      end

      def test_prefix
        doc = CSSPool.CSS <<-eocss
          @namespace xhtml url("http://www.w3.org/1999/xhtml/");
        eocss
        assert_equal 1, doc.namespaces.size
        assert_equal CSSPool::CSS::NamespaceRule, doc.namespaces[0].class
        assert_equal CSSPool::Terms::Ident, doc.namespaces[0].prefix.class
        assert_equal 'xhtml', doc.namespaces[0].prefix.value
        assert_equal CSSPool::Terms::URI, doc.namespaces[0].uri.class
        assert_equal 'http://www.w3.org/1999/xhtml/', doc.namespaces[0].uri.value
      end

      def test_multiple
        doc = CSSPool.CSS <<-eocss
          @namespace url("http://www.w3.org/1999/xhtml/");
          @namespace xul url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");
        eocss
        assert_equal 2, doc.namespaces.size
        assert_equal CSSPool::CSS::NamespaceRule, doc.namespaces[0].class
        assert_equal CSSPool::CSS::NamespaceRule, doc.namespaces[1].class
      end

    end
  end
end
