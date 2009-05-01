#include <crocodile_selector.h>

VALUE cCrocodileSelector;

VALUE Crocodile_Wrap_Selector(CRSelector * selector, VALUE statement)
{
  VALUE sel = Data_Wrap_Struct(cCrocodileSelector, 0, 0, selector);
  rb_iv_set(sel, "@statement", statement);
  return sel;
}

static VALUE next(VALUE self)
{
  CRSelector * selector;
  Data_Get_Struct(self, CRSelector, selector);

  if(NULL == selector->next) return Qnil;
  return Crocodile_Wrap_Selector(selector->next, rb_iv_get(self, "@statement"));
}

void init_crocodile_selector()
{
  VALUE crocodile = rb_define_module("Crocodile");
  VALUE node      = rb_define_class_under(crocodile, "Node", rb_cObject);
  VALUE klass     = rb_define_class_under(crocodile, "Selector", node);

  cCrocodileSelector = klass;

  rb_define_method(klass, "next", next, 0);
}
