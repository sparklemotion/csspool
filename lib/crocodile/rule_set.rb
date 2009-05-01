module Crocodile
  class RuleSet < Statement
    ###
    # Get a list of Selector for this RuleSet
    def selectors
      list = [selector]
      while list.last.next
        list << list.last.next
      end
      list
    end
  end
end
