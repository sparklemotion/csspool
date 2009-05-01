require 'helper'

module Crocodile
  class TestStatement < Crocodile::TestCase
    def setup
      super
      @document = Crocodile(<<-eocss)
        a { background: red; }
        li, p{ background: red; }
      eocss
      @statement = @document.statements.first
    end

    def test_statement_type
      assert_equal 1, @statement.statement_type
    end

    def test_ruleset_is_a_ruleset
      assert_instance_of Crocodile::RuleSet, @statement
    end

    def test_parent_sheet
      assert_equal @document, @statement.parent_sheet
    end

    def test_specificity
      assert_equal 0, @statement.specificity
    end

    def test_line
      assert_equal [0,0], @document.statements.map { |stmt| stmt.line }
    end

    def test_column
      assert_equal [0,0], @document.statements.map { |stmt| stmt.column }
    end

    def test_byte
      assert_equal [0,0], @document.statements.map { |stmt| stmt.byte }
    end
  end
end
