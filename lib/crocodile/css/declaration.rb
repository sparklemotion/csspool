module Crocodile
  module CSS
    class Declaration < Struct.new(:property, :expressions)
      include Crocodile::Visitable
    end
  end
end
