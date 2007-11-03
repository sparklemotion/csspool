require File.dirname(__FILE__) + "/helper"

class XPathTest < Test::Unit::TestCase
  def setup
    @parser = CSS::SAC::Parser.new()
    class << @parser.document_handler
      attr_accessor :selectors
      def start_selector(selectors)
        @selectors = selectors
      end
    end
  end
  
  # TODO: looks like attribute value quoting
  # might be broken on the css side?
  # this: input[type="text"] should be valid CSS
  # and probably not return the quotes in the node
  
  def test_any
    assert_xpath("//*", "*")
  end
  
  def test_element
    assert_xpath("//h1", "h1")
  end
  
  def test_id
    assert_xpath("//*[@id='foo']", "#foo")
  end
  
  def test_class
    assert_xpath("//*[contains(@class, 'foo')]", ".foo")
  end
    
  def test_attribute_with_no_value
    assert_xpath("//*[@checked]", "[checked]")
  end
  
  def test_attribute_with_value
    assert_xpath("//*[@type='text']", "[type=text]")
  end
  
  def test_hyphen_separated_attribute
    # the contains behavior is probably fine here
    assert_xpath("//*[contains(@type, 'text')]", "[type~=text]")    
  end
  
  def test_space_separated_attribute
    # the contains behavior is probably fine here
    assert_xpath("//*[contains(@type, 'text')]", "[type|=text]")    
  end
  
  def test_element_with_id
    assert_xpath("//h1[@id='monkey']", "h1#monkey")
  end
  
  def test_element_with_class
    assert_xpath("//h1[contains(@class, 'foo')]", "h1.foo")
  end
  
  def test_element_with_id_and_class
    assert_xpath("//h1[@id='monkey'][contains(@class, 'foo')]", "h1#monkey.foo")
  end
  
  def test_element_with_multiple_classes
    assert_xpath("//h1[contains(@class, 'foo')][contains(@class, 'bar')]", "h1.foo.bar")
  end
  
  def test_descendant
    assert_xpath("//div//p", "div p")
    assert_xpath("//div//*[contains(@class, 'angry')]", "div .angry")
  end
  
  def test_direct_descendant
    assert_xpath("//div/p", "div > p")
  end
  
  def test_sibling
    assert_xpath("//div/following-sibling::p", "div + p")
  end
  
  def test_safely_ignores_pseudoclasses
    assert_xpath("//a", "a:hover")
  end
  
  private
  
  def assert_xpath(xpath, css)
    assert_equal(xpath, selector_for(css).to_xpath)
  end
  
  def selector_for(string)
    selectors = selectors_for(string)
    assert_equal(1, selectors.length)
    selectors.first
  end
  
  def selectors_for(string)
    @parser.parse("#{string} {}")
    @parser.document_handler.selectors
  end
end
