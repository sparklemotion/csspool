require File.dirname(__FILE__) + "/helper"

class SelectorParserTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC::Parser.new()
    class << @sac.document_handler
      attr_reader :selectors
      def start_selector(selectors)
        @selectors = selectors
      end
    end
  end

  def test_adjacent
    @sac.parse('h1 + h2 { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)

    sel = selectors.first
    assert_equal(:SAC_DIRECT_ADJACENT_SELECTOR, sel.selector_type)

    sibling = sel.sibling_selector
    assert sibling
    assert_equal('h2', sibling.local_name)

    first = sel.selector
    assert first
    assert_equal('h1', first.local_name)
  end

  def test_descendant_non_direct
    @sac.parse('h1  h2 { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)

    sel = selectors.first
    assert_equal(:SAC_DESCENDANT_SELECTOR, sel.selector_type)

    ancestor = sel.ancestor_selector
    assert ancestor
    assert_equal('h1', ancestor.local_name)

    me = sel.selector
    assert me
    assert_equal('h2', me.local_name)
  end

  def test_descendant_direct
    @sac.parse('h1 > h2 { }')
    selectors = @sac.document_handler.selectors
    assert_equal(1, selectors.length)

    sel = selectors.first
    assert_equal(:SAC_CHILD_SELECTOR, sel.selector_type)

    ancestor = sel.ancestor_selector
    assert ancestor
    assert_equal('h1', ancestor.local_name)

    me = sel.selector
    assert me
    assert_equal('h2', me.local_name)
  end

  @@single_selector_tests = {
    :id => {
      :css   => '#foo { }',
      :value => '#foo',
      :type  => :SAC_ID_CONDITION,
    },
    :class => {
      :css    => '.foo { }',
      :value  => 'foo',
      :type   => :SAC_CLASS_CONDITION,
    },
    :attribute => {
      :css    => '[foo=bar] { }',
      :value  => 'bar',
      :type   => :SAC_ATTRIBUTE_CONDITION,
    },
    :pseudo => {
      :css    => ':clicked { }',
      :value  => 'clicked',
      :type   => :SAC_PSEUDO_CLASS_CONDITION,
    }
  }

  @@multiple_selector_tests = {
    :ids => {
      :css    => '#foo#bar#baz { }',
      :values => %w{ #foo #bar #baz },
      :types  => [:SAC_ID_CONDITION] * 3,
    },
    :classes => {
      :css    => '.foo.bar.baz { }',
      :values => %w{ foo bar baz },
      :types  => [:SAC_CLASS_CONDITION] * 3,
    },
    :attributes => {
      :css    => '[foo=bar][bar=baz] { }',
      :values => %w{ bar baz },
      :types  => [:SAC_ATTRIBUTE_CONDITION] * 2,
    },
    :pseudo => {
      :css    => ':clicked:hover { }',
      :values => %w{ clicked hover },
      :types  => [:SAC_PSEUDO_CLASS_CONDITION] * 2,
    }
  }

  @@single_selector_tests.each do |name,tests|
    define_method :"test_single_#{name}" do
      @sac.parse(tests[:css])
      selectors = @sac.document_handler.selectors
      assert_equal(1, selectors.length)

      selector = selectors.first
      assert_nil selector.simple_selector
      assert selector.condition
      assert_equal(:SAC_CONDITIONAL_SELECTOR, selector.selector_type)

      condition = selector.condition
      assert_equal(tests[:type], condition.condition_type)
      assert_equal(tests[:value], condition.value)
    end
  end

  @@multiple_selector_tests.each do |name,tests|
    define_method :"test_multiple_#{name}" do
      @sac.parse(tests[:css])
      selectors = @sac.document_handler.selectors
      assert_equal(1, selectors.length)

      selector = selectors.first
      assert_nil selector.simple_selector
      assert selector.condition
      assert_equal(:SAC_CONDITIONAL_SELECTOR, selector.selector_type)

      combined = reduce_combinator_condition(selector.condition)
      assert_equal(tests[:values].length, combined.length)
      assert_equal(tests[:values], combined.map { |x| x.value })
      assert_equal(tests[:types], combined.map { |x| x.condition_type })
    end
  end

  def reduce_combinator_condition(condition)
    conditions = []
    assert_equal(:SAC_AND_CONDITION, condition.condition_type)
    first = condition.first_condition
    second = condition.second_condition

    assert first
    assert second
    assert_not_equal(:SAC_AND_CONDITION, first.condition_type)
    conditions << first

    if second.condition_type == :SAC_AND_CONDITION
      conditions += reduce_combinator_condition(second)
    else
      conditions << second
    end
    conditions
  end
end
