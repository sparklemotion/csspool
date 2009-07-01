module Crocodile
  module Selectors
    class PseudoClass < Crocodile::Selectors::Additional
      attr_accessor :name
      attr_accessor :extra

      def initialize name, extra = nil
        @name = name
        @extra = extra
      end
    end
  end
end
