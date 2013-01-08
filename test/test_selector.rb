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

    def test_not_pseudo_class
      doc = CSSPool.CSS <<-eocss
        a:not(b) { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 'a', rs.selectors.first.simple_selectors.first.name
      assert_equal ':not(b)', rs.selectors.first.simple_selectors.first.additional_selectors.first.to_s
    end

    def test_attribute_prefix_match
      doc = CSSPool.CSS <<-eocss
        a[href^="http"] { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal Selectors::Attribute, rs.selectors.first.simple_selectors.first.additional_selectors.first.class
      assert_equal Selectors::Attribute::PREFIXMATCH, rs.selectors.first.simple_selectors.first.additional_selectors.first.match_way
    end

    def test_attribute_suffix_match
      doc = CSSPool.CSS <<-eocss
        a[href$="http"] { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal Selectors::Attribute, rs.selectors.first.simple_selectors.first.additional_selectors.first.class
      assert_equal Selectors::Attribute::SUFFIXMATCH, rs.selectors.first.simple_selectors.first.additional_selectors.first.match_way
    end

    def test_attribute_substring_match
      doc = CSSPool.CSS <<-eocss
        a[href*="http"] { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal Selectors::Attribute, rs.selectors.first.simple_selectors.first.additional_selectors.first.class
      assert_equal Selectors::Attribute::SUBSTRINGMATCH, rs.selectors.first.simple_selectors.first.additional_selectors.first.match_way
    end

    def test_general_sibling_selector
      doc = CSSPool.CSS <<-eocss
        a ~ b { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal :~, rs.selectors.first.simple_selectors[1].combinator
    end

    def test_element_with_namespace
      doc = CSSPool.CSS <<-eocss
        a|b { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 'b', rs.selectors.first.simple_selectors.first.name
      assert_equal 'a', rs.selectors.first.simple_selectors.first.namespace
    end

    def test_element_with_no_namespace
      doc = CSSPool.CSS <<-eocss
        |b { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 'b', rs.selectors.first.simple_selectors.first.name
      assert_equal nil, rs.selectors.first.simple_selectors.first.namespace
    end

    def test_element_with_any_namespace
      doc = CSSPool.CSS <<-eocss
        *|b { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 'b', rs.selectors.first.simple_selectors.first.name
      assert_equal '*', rs.selectors.first.simple_selectors.first.namespace
    end

    def test_universal_with_namespace
      doc = CSSPool.CSS <<-eocss
        a|* { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal Selectors::Universal, rs.selectors.first.simple_selectors.first.class
      assert_equal 'a', rs.selectors.first.simple_selectors.first.namespace
    end

    def test_universal_with_no_namespace
      doc = CSSPool.CSS <<-eocss
        |* { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal Selectors::Universal, rs.selectors.first.simple_selectors.first.class
      assert_equal nil, rs.selectors.first.simple_selectors.first.namespace
    end

    def test_universal_with_any_namespace
      doc = CSSPool.CSS <<-eocss
        *|* { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal Selectors::Universal, rs.selectors.first.simple_selectors.first.class
      assert_equal '*', rs.selectors.first.simple_selectors.first.namespace
    end

    def test_attribute_with_namespace
      doc = CSSPool.CSS <<-eocss
        a[b|c] { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal 'b', rs.selectors.first.simple_selectors.first.additional_selectors.first.namespace
      assert_equal 'c', rs.selectors.first.simple_selectors.first.additional_selectors.first.name
    end

    def test_attribute_with_no_namespace
      doc = CSSPool.CSS <<-eocss
        a[|c] { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal nil, rs.selectors.first.simple_selectors.first.additional_selectors.first.namespace
      assert_equal 'c', rs.selectors.first.simple_selectors.first.additional_selectors.first.name
    end

    def test_attribute_with_any_namespace
      doc = CSSPool.CSS <<-eocss
        a[*|c] { background: red; }
      eocss
      rs = doc.rule_sets.first
      assert_equal '*', rs.selectors.first.simple_selectors.first.additional_selectors.first.namespace
      assert_equal 'c', rs.selectors.first.simple_selectors.first.additional_selectors.first.name
    end

  end
end
