#include <crocodile_rule_set.h>

VALUE cCrocodileRuleSet;

static VALUE selector(VALUE self)
{
  CRStatement * rule_set;
  Data_Get_Struct(self, CRStatement, rule_set);


  if(NULL == rule_set->kind.ruleset->sel_list) return Qnil;

  return Crocodile_Wrap_Selector(rule_set->kind.ruleset->sel_list, self);
}

void init_crocodile_rule_set()
{
  VALUE crocodile = rb_define_module("Crocodile");
  VALUE stmt      = rb_define_class_under(crocodile, "Statement", rb_cObject);
  VALUE klass     = rb_define_class_under(crocodile, "RuleSet", stmt);
  cCrocodileRuleSet = klass;

  rb_define_private_method(klass, "selector", selector, 0);
}
