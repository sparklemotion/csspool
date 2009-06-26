require 'helper'

module Crocodile
  class TestCollection < Crocodile::TestCase
    def test_new
      assert Crocodile::Collection.new
      assert Crocodile::Collection.new { |url| }
    end

    def test_append
      collection = Crocodile::Collection.new
      collection << "div { background: green; }"
      assert_equal 1, collection.length
    end

    def test_collection_imports_stuff
      called = false
      collection = Crocodile::Collection.new do |url|
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

      collection = Crocodile::Collection.new do |url|
        css[url] || raise
      end

      collection << '@import url(foo.css);'
      assert_equal 4, collection.length
      assert_nil collection[0].parent
      assert_equal collection[0], collection[1].parent
      assert_equal collection[1], collection[2].parent
      assert_equal collection[2], collection[3].parent
    end

    def test_load_only_once
      css = {
        'foo.css' => '@import url("foo.css");',
      }

      collection = Crocodile::Collection.new do |url|
        css[url] || raise
      end

      collection << '@import url(foo.css);'

      assert_equal 2, collection.length
    end
  end
end
