require "css/sac/parser"

module CSS
  module SAC
    class << self
      def parse(text)
        parser = CSS::SAC::Parser.new
        parser.parse(text)
        parser
      end      
    end
  end
end
