require 'csspool/selectors/pseudo_class'
require 'csspool/selectors/pseudo_element'

module CSSPool
  module Selectors
    def Selectors.pseudo name
      css2_pseudo_elements = 
      if %w{after before first-letter first-line}.include? name
        PseudoElement.new name, true
      else
        PseudoClass.new name
      end
    end
  end
end
