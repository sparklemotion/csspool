module Crocodile
  module CSS
    class Media < Struct.new(:name, :parse_location)
      include Crocodile::Visitable
    end
  end
end
