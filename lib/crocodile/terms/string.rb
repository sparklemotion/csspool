module Crocodile
  module Terms
    class String < Ident
      def to_css
        "\"#{value}\""
      end
    end
  end
end
