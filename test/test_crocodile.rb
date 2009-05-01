require 'helper'

class TestCrocodile < Crocodile::TestCase
  def test_parse_string
    document = Crocodile(<<-eocss)
    a {
      background: red;
    }
    eocss
    assert document
  end

  def test_document_has_statements
    document = Crocodile(<<-eocss)
    a {
      background: red;
    }
    eocss
    assert document
    assert_equal 1, document.statements.length
  end
end
