require "css/sac/document_handler"
require "css/sac/generated_parser"
require "css/sac/tokenizer"

module CSS
  module SAC
    class Parser < CSS::SAC::GeneratedParser
      TOKENIZER = Tokenizer.new
      
      attr_accessor :document_handler, :error_handler

      def initialize
        @error_handler = lambda { |error_token_id, error_value, value_stack|
          puts '#' * 50
          puts token_to_str(error_token_id)
          p error_value
          p value_stack
          puts '#' * 50
        }

        @document_handler = DocumentHandler.new()
      end

      def parse_style_sheet(string)
        @yydebug = true
        @tokens = TOKENIZER.tokenize(string)
        @position = 0

        self.document_handler.start_document(string)
        do_parse
        self.document_handler.end_document(string)
      end

      alias :parse :parse_style_sheet

      def next_token
        return [false, false] if @position >= @tokens.length 

        n_token = @tokens[@position]
        @position += 1
        if n_token.name == :COMMENT
          self.document_handler.comment(n_token.value)
          return next_token
        end
        n_token.to_racc_token
      end

      # Returns the parser version.  We return CSS2, but its actually
      # CSS2.1.  No font-face tags.  Sorry.
      def parser_version
        "http://www.w3.org/TR/REC-CSS2"
      end

      def on_error(error_token_id, error_value, value_stack)
        error_handler.call(error_token_id, error_value, value_stack)
      end
      private :on_error
    end
  end
end
