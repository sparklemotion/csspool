require 'helper'

module CSSPool
  class TestCollection < CSSPool::TestCase
    def test_new
      assert CSSPool::Collection.new
      assert CSSPool::Collection.new { |url| }
    end

    def test_append
      collection = CSSPool::Collection.new
      collection << "div { background: green; }"
      assert_equal 1, collection.length
    end

    def test_collection_imports_stuff
      called = false
      collection = CSSPool::Collection.new do |url|
        called = true
        assert_equal 'hello.css', url
        "div { background: red; }"
      end

      collection << '@import url(hello.css);'
      assert called, "block was not called"
      assert_equal 2, collection.length
    end

    def test_collection_imports_imports_imports
      css = {
        'foo.css' => '@import url("bar.css");',
        'bar.css' => '@import url("baz.css");',
        'baz.css' => 'div { background: red; }',
      }

      collection = CSSPool::Collection.new do |url|
        css[url] || raise
      end

      collection << '@import url(foo.css);'
      assert_equal 4, collection.length
      assert_nil collection.last.parent
      assert_equal collection[-2].parent, collection.last
      assert_equal collection[-3].parent, collection[-2]
      assert_equal collection[-4].parent, collection[-3]
    end

    def test_load_only_once
      css = {
        'foo.css' => '@import url("foo.css");',
      }

      collection = CSSPool::Collection.new do |url|
        css[url] || raise
      end

      collection << '@import url(foo.css);'

      assert_equal 2, collection.length
    end

    def test_each
      css = {
        'foo.css' => '@import url("foo.css");',
      }

      collection = CSSPool::Collection.new do |url|
        css[url] || raise(url.inspect)
      end

      collection << '@import url(foo.css);'

      list = []
      collection.each do |thing|
        list << thing
      end

      assert_equal 2, list.length
    end
  end
end
