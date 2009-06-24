module Crocodile
  module CSS
    class ImportRule < Struct.new(:uri, :namespace, :media, :parse_location)
      include Crocodile::Visitable
    end
  end
end
