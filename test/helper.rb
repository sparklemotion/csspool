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

      def initialize
        @start_documents = []
        @end_documents = []
      end

      def start_document
        @start_documents << true
      end

      def end_document
        @end_documents << true
      end
    end
  end
end
