module Crocodile
  module Selectors
    class Id < Crocodile::Selectors::Additional
      attr_accessor :name

      def initialize name
        @name = name
      end
    end
  end
end
