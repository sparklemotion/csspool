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
      assert_equal [1, 2, 1000001, 1001, 1000001, 1001, 1001, 2001],
        specs
    end
  end
end
