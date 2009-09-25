module CSSPool
  module SAC
    class Document
      def start_document
      end

      def end_document
      end

      def charset name, location
      end

      def import_style media_list, uri, default_ns = nil, location = {}
      end

      def start_selector selector_list
      end

      def end_selector selector_list
      end

      def property name, expression, important
      end

      def comment comment
      end

      def start_media media_list, parse_location = {}
      end

      def end_media media_list, parse_location = {}
      end
    end
  end
end
