require File.dirname(__FILE__) + "/helper"

# http://www.w3.org/TR/REC-CSS2/cascade.html#specificity
# *             {}  /* a=0 b=0 c=0 -> specificity =   0 */
# LI            {}  /* a=0 b=0 c=1 -> specificity =   1 */
# UL LI         {}  /* a=0 b=0 c=2 -> specificity =   2 */
# UL OL+LI      {}  /* a=0 b=0 c=3 -> specificity =   3 */
# H1 + *[REL=up]{}  /* a=0 b=1 c=1 -> specificity =  11 */
# UL OL LI.red  {}  /* a=0 b=1 c=3 -> specificity =  13 */ 
# LI.red.level  {}  /* a=0 b=2 c=1 -> specificity =  21 */
# #x34y         {}  /* a=1 b=0 c=0 -> specificity = 100 */ 
class SpecificityTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC::Parser.new()
    class << @sac.document_handler
      attr_accessor :selectors
      alias :start_selector :selectors=
    end
  end

  def test_star
    @sac.parse('* {}')
    selector = @sac.document_handler.selectors.first
    assert_not_nil selector
    assert_equal [0, 0, 0, 0], selector.specificity
  end

  def test_li
    @sac.parse('li {}')
    selector = @sac.document_handler.selectors.first
    assert_not_nil selector
    assert_equal [0, 0, 0, 1], selector.specificity
  end

  def test_ul_li
    @sac.parse('ul li {}')
    selector = @sac.document_handler.selectors.first
    assert_not_nil selector
    assert_equal [0, 0, 0, 2], selector.specificity
  end

  def test_ul_ol_plus_li
    @sac.parse('ul ol+li {}')
    selector = @sac.document_handler.selectors.first
    assert_not_nil selector
    assert_equal [0, 0, 0, 3], selector.specificity
  end

  def test_h1_attributes
    @sac.parse('h1 + *[REL=up] {}')
    selector = @sac.document_handler.selectors.first
    assert_not_nil selector
    assert_equal [0, 0, 1, 1], selector.specificity
  end

  def test_one_class_selector
    @sac.parse('ul ol li.red {}')
    selector = @sac.document_handler.selectors.first
    assert_not_nil selector
    assert_equal [0, 0, 1, 3], selector.specificity
  end

  def test_two_class_selectors
    @sac.parse('li.red.level {}')
    selector = @sac.document_handler.selectors.first
    assert_not_nil selector
    assert_equal [0, 0, 2, 1], selector.specificity
  end

  def test_id_selector
    @sac.parse('#x34y {}')
    selector = @sac.document_handler.selectors.first
    assert_not_nil selector
    assert_equal [0, 1, 0, 0], selector.specificity
  end
end
