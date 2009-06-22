module Crocodile
  module Terms
    class Function < Crocodile::Node
      attr_accessor :name
      attr_accessor :params
      def initialize name, params
        @name   = name
        @params = params
      end
    end
  end
end
