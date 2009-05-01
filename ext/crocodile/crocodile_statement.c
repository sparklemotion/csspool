#include <crocodile_statement.h>

VALUE cCrocodileStatement;
VALUE cCrocodileRuleSet;

static mark(CRStatement * statement)
{
  rb_gc_mark((VALUE)statement->parent_sheet->app_data);
}

VALUE Crocodile_Wrap_Statement(CRStatement * statement)
{
  VALUE klass;
  switch(statement->type)
  {
    case RULESET_STMT:
      klass = cCrocodileRuleSet;
      break;
    default:
      klass = cCrocodileStatement;
  }
  return Data_Wrap_Struct(klass, mark, NULL, statement);
}

VALUE statement_type(VALUE self)
{
  CRStatement * statement;
  Data_Get_Struct(self, CRStatement, statement);
  return INT2NUM(statement->type);
}

void init_crocodile_statement()
{
  VALUE crocodile = rb_define_module("Crocodile");
  VALUE klass     = rb_define_class_under(crocodile, "Statement", rb_cObject);

  cCrocodileStatement = klass;
  cCrocodileRuleSet   = rb_define_class_under(crocodile, "RuleSet", klass);

  rb_define_method(klass, "statement_type", statement_type, 0);
}
