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
      attr_accessor :charsets, :import_styles

      def initialize
        @start_documents = []
        @end_documents = []
        @charsets = []
        @import_styles = []
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

      def import_style media_list, uri, default_ns, location
        @import_styles << [media_list, uri, default_ns, location]
      end
    end
  end
end
