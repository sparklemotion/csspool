module Crocodile
  module Terms
    class Function < Crocodile::Node
      attr_accessor :name
      attr_accessor :params
      attr_accessor :parse_location
      def initialize name, params, parse_location
        @name   = name
        @params = params
        @parse_location = parse_location
      end
    end
  end
end
