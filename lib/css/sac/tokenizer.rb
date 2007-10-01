require "css/sac/lexeme"
require "css/sac/token"

module CSS
  module SAC
    class Tokenizer
      def initialize(&block)
        @lexemes = []
        @macros = {}

        # http://www.w3.org/TR/CSS21/syndata.html
        macro(:h, /([0-9a-f])/ )
        macro(:nonascii, /([\200-\377])/ )
        macro(:nl, /(\n|\r\n|\r|\f)/ )
        macro(:unicode, /(\\#{m(:h)}{1,6}(\r\n|[ \t\r\n\f])?)/ )
        macro(:escape, /(#{m(:unicode)}|\\[^\r\n\f0-9a-f])/ )
        macro(:nmstart, /([_a-z]|#{m(:nonascii)}|#{m(:escape)})/ )
        macro(:nmchar, /([_a-z0-9-]|#{m(:nonascii)}|#{m(:escape)})/ )
        macro(:string1, /(\"([^\n\r\f\\\"]|\\#{m(:nl)}|#{m(:escape)})*\")/ )
        macro(:string2, /(\'([^\n\r\f\\']|\\#{m(:nl)}|#{m(:escape)})*\')/ )
        macro(:invalid1, /(\"([^\n\r\f\\\"]|\\#{m(:nl)}|#{m(:escape)})*)/ )
        macro(:invalid2, /(\'([^\n\r\f\\']|\\#{m(:nl)}|#{m(:escape)})*)/ )
        macro(:comment, /(\/\*[^*]*\*+([^\/*][^*]*\*+)*\/)/ )
        macro(:ident, /(-?#{m(:nmstart)}#{m(:nmchar)}*)/ )
        macro(:name, /(#{m(:nmchar)}+)/ )
        macro(:num, /([0-9]+|[0-9]*\.[0-9]+)/ )
        macro(:string, /(#{m(:string1)}|#{m(:string2)})/ )
        macro(:invalid, /(#{m(:invalid1)}|#{m(:invalid2)})/ )
        macro(:url, /(([!#\$%&*-~]|#{m(:nonascii)}|#{m(:escape)})*)/ )
        macro(:s, /([ \t\r\n\f]+)/ )
        macro(:w, /(#{m(:s)}?)/ )
        macro(:A, /(a|\\0{0,4}(41|61)(\r\n|[ \t\r\n\f])?)/ )
        macro(:C, /(c|\\0{0,4}(43|63)(\r\n|[ \t\r\n\f])?)/ )
        macro(:D, /(d|\\0{0,4}(44|64)(\r\n|[ \t\r\n\f])?)/ )
        macro(:E, /(e|\\0{0,4}(45|65)(\r\n|[ \t\r\n\f])?)/ )
        macro(:G, /(g|\\0{0,4}(47|67)(\r\n|[ \t\r\n\f])?|\\g)/ )
        macro(:H, /(h|\\0{0,4}(48|68)(\r\n|[ \t\r\n\f])?|\\h)/ )
        macro(:I, /(i|\\0{0,4}(49|69)(\r\n|[ \t\r\n\f])?|\\i)/ )
        macro(:K, /(k|\\0{0,4}(4b|6b)(\r\n|[ \t\r\n\f])?|\\k)/ )
        macro(:M, /(m|\\0{0,4}(4d|6d)(\r\n|[ \t\r\n\f])?|\\m)/ )
        macro(:N, /(n|\\0{0,4}(4e|6e)(\r\n|[ \t\r\n\f])?|\\n)/ )
        macro(:O, /(o|\\0{0,4}(51|71)(\r\n|[ \t\r\n\f])?|\\o)/ )
        macro(:P, /(p|\\0{0,4}(50|70)(\r\n|[ \t\r\n\f])?|\\p)/ )
        macro(:R, /(r|\\0{0,4}(52|72)(\r\n|[ \t\r\n\f])?|\\r)/ )
        macro(:S, /(s|\\0{0,4}(53|73)(\r\n|[ \t\r\n\f])?|\\s)/ )
        macro(:T, /(t|\\0{0,4}(54|74)(\r\n|[ \t\r\n\f])?|\\t)/ )
        macro(:X, /(x|\\0{0,4}(58|78)(\r\n|[ \t\r\n\f])?|\\x)/ )
        macro(:Z, /(z|\\0{0,4}(5a|7a)(\r\n|[ \t\r\n\f])?|\\z)/ )

        token(:S, /#{m(:s)}/)

        token :COMMENT do |patterns|
          patterns << /\/\*[^*]*\*+([^\/*][^*]*\*+)*\//
          patterns << /#{m(:s)}+\/\*[^*]*\*+([^\/*][^*]*\*+)*\//
        end

        token(:CDO, /<!--/)
        token(:CDC, /-->/)
        token(:INCLUDES, /~=/)
        token(:DASHMATCH, /\|=/)
        token(:LBRACE, /#{m(:w)}\{/)
        token(:PLUS, /#{m(:w)}\+/)
        token(:GREATER, /#{m(:w)}>/)
        token(:COMMA, /#{m(:w)},/)
        token(:STRING, /#{m(:string)}/)
        token(:INVALID, /#{m(:invalid)}/)
        token(:IDENT, /#{m(:ident)}/)
        token(:HASH, /##{m(:name)}/)
        token(:IMPORT_SYM, /@#{m(:I)}#{m(:M)}#{m(:P)}#{m(:O)}#{m(:R)}#{m(:T)}/)
        token(:PAGE_SYM, /@#{m(:P)}#{m(:A)}#{m(:G)}#{m(:E)}/)
        token(:MEDIA_SYM, /@#{m(:M)}#{m(:E)}#{m(:D)}#{m(:I)}#{m(:A)}/)
        token(:CHARSET_SYM, /@#{m(:C)}#{m(:H)}#{m(:A)}#{m(:R)}#{m(:S)}#{m(:E)}#{m(:T)}/)
        token(:IMPORTANT_SYM, /!(#{m(:w)}|#{m(:comment)})*#{m(:I)}#{m(:M)}#{m(:P)}#{m(:O)}#{m(:R)}#{m(:T)}#{m(:A)}#{m(:N)}#{m(:T)}/)
        token(:EMS, /#{m(:num)}#{m(:E)}#{m(:M)}/)
        token(:EXS, /#{m(:num)}#{m(:E)}#{m(:X)}/)

        token :LENGTH do |patterns|
          patterns << /#{m(:num)}#{m(:P)}#{m(:X)}/
          patterns << /#{m(:num)}#{m(:C)}#{m(:M)}/
          patterns << /#{m(:num)}#{m(:M)}#{m(:M)}/
          patterns << /#{m(:num)}#{m(:I)}#{m(:N)}/
          patterns << /#{m(:num)}#{m(:P)}#{m(:T)}/
          patterns << /#{m(:num)}#{m(:P)}#{m(:C)}/
        end

        token :ANGLE do |patterns|
          patterns << /#{m(:num)}#{m(:D)}#{m(:E)}#{m(:G)}/
          patterns << /#{m(:num)}#{m(:R)}#{m(:A)}#{m(:D)}/
          patterns << /#{m(:num)}#{m(:G)}#{m(:R)}#{m(:A)}#{m(:D)}/
        end

        token :TIME do |patterns|
          patterns << /#{m(:num)}#{m(:M)}#{m(:S)}/
          patterns << /#{m(:num)}#{m(:S)}/
        end

        token :FREQ do |patterns|
          patterns << /#{m(:num)}#{m(:H)}#{m(:Z)}/
          patterns << /#{m(:num)}#{m(:K)}#{m(:H)}#{m(:Z)}/
        end

        token(:DIMENSION, /#{m(:num)}#{m(:ident)}/)
        token(:PERCENTAGE, /#{m(:num)}%/)
        token(:NUMBER, /#{m(:num)}/)

        token :URI do |patterns|
          patterns << /url\(#{m(:w)}#{m(:string)}#{m(:w)}\)/
          patterns << /url\(#{m(:w)}#{m(:url)}#{m(:w)}\)/
        end

        token(:FUNCTION, /#{m(:ident)}\(/)

        yield self if block_given?
      end
      
      def tokenize(string)
        tokens = []
        pos = 0
        
        until string.empty?
          matches = @lexemes.collect do |lexeme|
            match = lexeme.pattern.match(string) || next
            next unless match.pre_match.length == 0 && match.to_s.length > 0
            Token.new(lexeme.name, match.to_s, pos)
          end.compact.sort_by { |x| x.value.length }

          if matches.empty?
            matches << DelimiterToken.new(/^./.match(string).to_s, pos)
          end

          token = matches.last
          tokens << token
          string = string.slice(Range.new(token.value.length, -1))
          pos += token.value.length
        end
        
        tokens
      end
      
      private
      
      def token(name, pattern=nil, &block)
        @lexemes << Lexeme.new(name, pattern, &block)
      end

      def macro(name, regex=nil)
        regex ? @macros[name] = regex : @macros[name].source
      end

      alias :m :macro
    end
  end
end
