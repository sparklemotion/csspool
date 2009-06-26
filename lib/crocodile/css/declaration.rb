module Crocodile
  module CSS
    class Declaration < Struct.new(:property, :expressions, :important, :rule_set)
      include Crocodile::Visitable
      alias :important? :important
    end
  end
end
