class ConditionTestCase < Test::Unit::TestCase
  include CSS::SAC::Conditions

  Node = Struct.new(:name, :parent, :child, :next_sibling, :attributes)
  undef :default_test
end
