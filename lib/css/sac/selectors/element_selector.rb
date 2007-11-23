require "css/sac/selectors"

module CSS
  module SAC
    module Selectors
      class ElementSelector < SimpleSelector
        attr_reader :local_name
        alias :name :local_name

        def initialize(name)
          super(:SAC_ELEMENT_NODE_SELECTOR)
          @local_name = name
        end

        def to_css
          local_name
        end

        def to_xpath(prefix=true)
          atoms = [local_name]
          atoms.unshift("//") if prefix
          atoms.join
        end

        def specificity
          1
        end

        def ==(other)
          super && name == other.name
        end

        def hash
          name.hash
        end
      end
    end
  end
end
