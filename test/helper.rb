require "test/unit"
require "csspool"

module CSSPool
  class TestCase < Test::Unit::TestCase
    unless RUBY_VERSION >= '1.9'
      undef :default_test
    end

    ASSET_DIR = File.join(File.dirname(__FILE__), 'files')

    class MyDoc < CSSPool::CSS::DocumentHandler
      attr_accessor :start_documents, :end_documents
      attr_accessor :charsets, :import_styles, :document_queries, :comments, :start_selectors
      attr_accessor :end_selectors, :properties, :supports_rules

      def initialize
        @start_documents  = []
        @end_documents    = []
        @charsets         = []
        @import_styles    = []
        @document_queries = []
        @supports_rules   = []
        @comments         = []
        @start_selectors  = []
        @end_selectors    = []
        @properties       = []
      end

      def property declaration
        @properties << [declaration.property, declaration.expressions]
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

      def import_style media_list, uri, default_ns = nil, location = {}
        @import_styles << [media_list, uri, default_ns, location]
      end

      def document_query string
        @document_queries << string
      end

      def namespace_declaration prefix, uri, location
        @import_styles << [prefix, uri, location]
      end

      def comment string
        @comments << string
      end

      def start_selector selectors
        @start_selectors << selectors
      end

      def end_selector selectors
        @end_selectors << selectors
      end
    end
  end
end
