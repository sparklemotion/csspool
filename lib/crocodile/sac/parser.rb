module Crocodile
  module SAC
    class Parser
      attr_accessor :document

      def initialize document = Crocodile::SAC::Document.new
        @document = document
        @selector_stack = []
      end

      def parse string
        parse_memory(string, 5)
      end

      private
      def push selectors
        @selector_stack << selectors
      end

      def pop
        @selector_stack.pop
      end

      def parse_memory string, encoding
        parser = LibCroco::Parser.new(
          LibCroco.cr_parser_new_from_buf(
            string,
            string.length,
            5,
            0
          )
        )
        sac_handler =
          LibCroco::CSSSACHandler.new(LibCroco.cr_doc_handler_new)

        sac_handler[:start_document] = lambda { |parser|
          @document.start_document
        }
        sac_handler[:end_document] = lambda { |parser|
          @document.end_document
        }
        sac_handler[:charset] = lambda { |dh, name, location|
          @document.charset(
            LibCroco.cr_string_peek_raw_str(name).read_string,
            LibCroco::CRParsingLocation.new(location).to_h
          )
        }

        LibCroco.cr_parser_set_sac_handler(parser, sac_handler)
        LibCroco.cr_parser_parse(parser)
        LibCroco.cr_doc_handler_destroy(sac_handler)
      end
    end
  end
end
