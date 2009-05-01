require 'helper'

module Crocodile
  class TestRuleSet < Crocodile::TestCase
    def setup
      super
      @document = Crocodile(<<-eocss)
        a { background: red; }
        li, p { background: red; }
      eocss
      @ruleset = @document.statements.first
    end

    def test_selector
      class << @ruleset
        public :selector
      end
      assert @ruleset.selector
    end

    def test_selector_list
      assert_equal [1,2], @document.statements.map { |stmt|
        stmt.selectors.length
      }
    end
  end
end
