require 'csspool/selectors/pseudo_class'
require 'csspool/selectors/pseudo_element'

module CSSPool
  module Selectors
    def self.pseudo name
      # FIXME: This is a bit of an ugly solution. Should be able to handle it
      # more elegantly, and without calling out css2
      css2_pseudo_elements =
      if %w{after before first-letter first-line}.include? name
        PseudoElement.new name, true
      else
        PseudoClass.new name
      end
    end
  end
end
