module CSSPool
  module Terms
    class Function < CSSPool::Node
      attr_accessor :name
      attr_accessor :params
      attr_accessor :parse_location
      attr_accessor :operator

      def initialize name, params = [], operator = nil, parse_location = nil
        @name   = name
        @params = params
        @operator = operator
        @parse_location = parse_location
      end
    end
  end
end
