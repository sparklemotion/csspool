module Crocodile
  module Visitable
    def accept target
      target.accept self
    end

    def to_css
      accept Visitors::ToCSS.new
    end
  end
end
