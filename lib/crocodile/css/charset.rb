module Crocodile
  module CSS
    class Charset < Struct.new(:name, :parse_location)
      include Crocodile::Visitable
    end
  end
end
