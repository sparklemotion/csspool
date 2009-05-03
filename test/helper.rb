require "test/unit"
require "crocodile"

module Crocodile
  class TestCase < Test::Unit::TestCase
    unless RUBY_VERSION >= '1.9'
      undef :default_test
    end

    ASSET_DIR = File.join(File.dirname(__FILE__), 'files')

    class MyDoc < Crocodile::SAC::Document
      attr_accessor :start_documents, :end_documents
      attr_accessor :charsets

      def initialize
        @start_documents = []
        @end_documents = []
        @charsets = []
      end

      def start_document
        @start_documents << true
      end

      def end_document
        @end_documents << true
      end

      def charset name, location
        @charsets << [name, location]
      end
    end
  end
end
