module CSSPool
  module CSS
    class Media < Struct.new(:name, :parse_location)
      include CSSPool::Visitable
    end
  end
end
