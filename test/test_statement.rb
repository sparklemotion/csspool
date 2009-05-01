require 'helper'

module Crocodile
  class TestStatement < Crocodile::TestCase
    def setup
      super
      @document = Crocodile(<<-eocss)
        a { background: red; }
      eocss
    end

    def test_statement_type
      set = @document.statements.first
      assert_equal 1, set.statement_type
    end

    def test_ruleset_is_a_ruleset
      set = @document.statements.first
      assert_instance_of Crocodile::RuleSet, set
    end
  end
end
