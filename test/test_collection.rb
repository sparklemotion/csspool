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
  end
end
