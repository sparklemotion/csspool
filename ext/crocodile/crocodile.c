#include <crocodile.h>

VALUE mCrocodile;
VALUE mCrocodileSelectors;
VALUE mCrocodileTerms;

void Init_crocodile()
{
  mCrocodile = rb_define_module("Crocodile");
  mCrocodileSelectors = rb_define_module_under(mCrocodile, "Selectors");
  mCrocodileTerms = rb_define_module_under(mCrocodile, "Terms");

  init_crocodile_document();
  init_crocodile_statement();
  init_crocodile_rule_set();
  init_crocodile_selector();
  init_crocodile_sac_parser();
}
