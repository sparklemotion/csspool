#ifndef CROCODILE_STATEMENT
#define CROCODILE_STATEMENT

#include <crocodile.h>

extern VALUE cCrocodileStatement;

VALUE Crocodile_Wrap_Statement(CRStatement * statement);
void init_crocodile_statement();

#endif
