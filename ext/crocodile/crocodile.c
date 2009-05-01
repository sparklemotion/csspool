#include <crocodile.h>

VALUE mCrocodile;

void Init_crocodile()
{
  mCrocodile = rb_define_module("Crocodile");
  init_crocodile_document();
  init_crocodile_statement();
}
