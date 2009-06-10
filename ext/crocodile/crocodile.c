#include <crocodile.h>

VALUE mCrocodile;
VALUE mCrocodileSelectors;
VALUE mCrocodileTerms;

void Init_crocodile()
{
  mCrocodile = rb_define_module("Crocodile");
  mCrocodileSelectors = rb_define_module_under(mCrocodile, "Selectors");
  mCrocodileTerms = rb_define_module_under(mCrocodile, "Terms");

  init_crocodile_sac_parser();
}
