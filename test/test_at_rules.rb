require File.dirname(__FILE__) + "/helper"

class AtRulesTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC::Parser.new
  end

  AT_RULES = {
    :charset   => ['@charset "UTF-8";', 0],
    :import    => ['@import "screen.css";', 0],
    :namespace => ['@namespace foo url(http://www.example.com);', 0],
    :media     => ['@media print{#nav,#aside{display:none}}', 2],
    :page      => ['@page{size:8.5in 11in}', 0], 
    :font_face => ['@font-face{font-family:"ex";src:url(http://www.example.com)}', 0],
    :charset_space   => ['@charset "UTF-8" ;', 0],
    :import_space    => ['@import "screen.css" ;', 0],
    :namespace_space => ['@namespace foo url(http://www.example.com) ;', 0],
  }

  AT_RULES.each do |at_rule,(css,matching_rule_count)|
    define_method :"test_#{at_rule}" do
      label = at_rule.to_s.tr '_', '-'

      css_doc = @sac.parse(css + 'p { text-align: center }')
      assert css_doc.rules.size >= 1, "CSS not parsed with @#{label} at-rule"
      assert_equal matching_rule_count + 1, css_doc.rules.size, "Number of CSS rules parsed incorrectly when @#{label} at-rule used"
    end

    define_method :"test_with_space_#{at_rule}" do
      label = at_rule.to_s.tr '_', '-'

      css_doc = @sac.parse(css + " html {text-align: center}")
      assert css_doc.rules.size >= 1, "CSS not parsed with @#{label} at-rule"
      assert_equal matching_rule_count + 1, css_doc.rules.size, "Number of CSS rules parsed incorrectly when @#{label} at-rule used"
    end
  end
end
