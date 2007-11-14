require "css/sac/parser"
require "css/stylesheet"

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
