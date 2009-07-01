require 'helper'

module Crocodile
  class TestSelector < Crocodile::TestCase
    def test_specificity
      doc = Crocodile.CSS <<-eocss
        *, foo > bar, #hover, :hover, div#a, a.foo, a:hover, a[href][int="10"]{ background: red; }
      eocss
      selectors = doc.rule_sets.first.selectors
      specs = selectors.map do |sel|
        sel.specificity
      end
      assert_equal [[0, 0, 1],
       [0, 0, 2],
       [1, 0, 1],
       [0, 1, 1],
       [1, 0, 1],
       [0, 1, 1],
       [0, 1, 1],
       [0, 2, 1]], specs
    end

    def test_selector_knows_its_ruleset
      doc = Crocodile.CSS <<-eocss
        a[href][int="10"]{ background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal rs, rs.selectors.first.rule_set
    end

    def test_selector_gets_declarations
      doc = Crocodile.CSS <<-eocss
        a[href][int="10"]{ background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal rs.declarations, rs.selectors.first.declarations
    end

    def test_declaration_should_know_ruleset
      doc = Crocodile.CSS <<-eocss
        a[href][int="10"]{ background: red; }
      eocss
      rs = doc.rule_sets.first
      rs.declarations.each { |del| assert_equal rs, del.rule_set }
    end
  end
end
