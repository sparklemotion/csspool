module CSSPool
  module CSS
    class Charset < Struct.new(:name, :parse_location)
      include CSSPool::Visitable
    end
  end
end
