module Crocodile
  module CSS
    class Declaration < Struct.new(:property, :expressions, :important, :rule_set)
      include Crocodile::Visitable
      alias :important? :important

      def value
        expressions.map { |exp| exp.to_css }.join
      end
    end
  end
end
