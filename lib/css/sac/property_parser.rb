require "css/sac/generated_property_parser"

module CSS
  module SAC
    class PropertyParser < CSS::SAC::GeneratedPropertyParser
      def initialize
        @tokens = []
        @token_table = Racc_arg[10]
      end

      def parse_tokens(tokens)
        @tokens = tokens.find_all { |x| x.name != :S }.map { |token|
          if @token_table.has_key?(token.value)
            [token.value, token.value]
          else
            if token.name == :delim && !@token_table.has_key?(token.value)
              nil
            else
              token.to_racc_token
            end
          end
        }.compact

        begin
          return do_parse
        rescue ParseError => e
          return nil
        end
      end

      private
      def next_token
        return [false, false] if @tokens.empty?
        @tokens.shift
      end
    end
  end
end
