require 'helper'

module Crocodile
  module CSS
    class TestDeclaration < Crocodile::TestCase
      def test_value
        doc = Crocodile.CSS <<-eocss
          div { background: red; }
        eocss
        decl = doc.rule_sets.first.declarations.first
        assert_equal 'red', decl.value
      end
    end
  end
end
