module CSSPool
  module Visitable
    def accept target
      target.accept self
    end

    def to_css
      accept Visitors::ToCSS.new
    end
    alias :to_s :to_css
  end
end
