require 'helper'

module CSSPool
  class TestSelector < CSSPool::TestCase
    def test_specificity
      doc = CSSPool.CSS <<-eocss
        *, foo > bar, #hover, :hover, div#a, a.foo, a:hover, a[href][int="10"], :before, ::before { background: red; }
      eocss
      selectors = doc.rule_sets.first.selectors
      specs = selectors.map do |sel|
        sel.specificity
      end
      assert_equal [
       [0, 0, 1],
       [0, 0, 2],
       [1, 0, 0],
       [0, 1, 0],
       [1, 0, 1],
       [0, 1, 1],
       [0, 1, 1],
       [0, 2, 1],
       [0, 0, 1],
       [0, 0, 1]
      ], specs
    end

    def test_selector_knows_its_ruleset
      doc = CSSPool.CSS <<-eocss
        a[href][int="10"]{ background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal rs, rs.selectors.first.rule_set
    end

    def test_selector_gets_declarations
      doc = CSSPool.CSS <<-eocss
        a[href][int="10"]{ background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal rs.declarations, rs.selectors.first.declarations
    end

    def test_declaration_should_know_ruleset
      doc = CSSPool.CSS <<-eocss
        a[href][int="10"]{ background: red; }
      eocss
      rs = doc.rule_sets.first
      rs.declarations.each { |del| assert_equal rs, del.rule_set }
    end

    def test_nth_integer
      doc = CSSPool.CSS <<-eocss
        a:nth-child(1) { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 'nth-child', rs.selectors.first.simple_selectors.first.additional_selectors.first.name
      assert_equal '1', rs.selectors.first.simple_selectors.first.additional_selectors.first.extra
    end

    def test_nth_negative_integer
      doc = CSSPool.CSS <<-eocss
        a:nth-child(-1) { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 'nth-child', rs.selectors.first.simple_selectors.first.additional_selectors.first.name
      assert_equal '-1', rs.selectors.first.simple_selectors.first.additional_selectors.first.extra
    end

    def test_nth_n_syntax
      doc = CSSPool.CSS <<-eocss
        a:nth-child(-2n-1) { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 'nth-child', rs.selectors.first.simple_selectors.first.additional_selectors.first.name
      assert_equal '-2n-1', rs.selectors.first.simple_selectors.first.additional_selectors.first.extra
    end

    def test_nth_n_syntax_with_whitespace
      doc = CSSPool.CSS <<-eocss
        a:nth-child( -2n - 1 ) { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 'nth-child', rs.selectors.first.simple_selectors.first.additional_selectors.first.name
      assert_equal ' -2n - 1 ', rs.selectors.first.simple_selectors.first.additional_selectors.first.extra
    end

    def test_nth_odd
      doc = CSSPool.CSS <<-eocss
        a:nth-child(odd) { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 'nth-child', rs.selectors.first.simple_selectors.first.additional_selectors.first.name
      assert_equal 'odd', rs.selectors.first.simple_selectors.first.additional_selectors.first.extra
    end

    def test_nth_even
      doc = CSSPool.CSS <<-eocss
        a:nth-child(even) { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 'nth-child', rs.selectors.first.simple_selectors.first.additional_selectors.first.name
      assert_equal 'even', rs.selectors.first.simple_selectors.first.additional_selectors.first.extra
    end

  end
end
