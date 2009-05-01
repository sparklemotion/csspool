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

VALUE parent_sheet(VALUE self)
{
  CRStatement * statement;
  Data_Get_Struct(self, CRStatement, statement);
  return (VALUE)statement->parent_sheet->app_data;
}

VALUE specificity(VALUE self)
{
  CRStatement * statement;
  Data_Get_Struct(self, CRStatement, statement);
  return INT2NUM(statement->specificity);
}

VALUE line(VALUE self)
{
  CRStatement * statement;
  Data_Get_Struct(self, CRStatement, statement);
  return INT2NUM(statement->location.line);
}

VALUE column(VALUE self)
{
  CRStatement * statement;
  Data_Get_Struct(self, CRStatement, statement);
  return INT2NUM(statement->location.column);
}

VALUE byte(VALUE self)
{
  CRStatement * statement;
  Data_Get_Struct(self, CRStatement, statement);
  return INT2NUM(statement->location.byte_offset);
}

void init_crocodile_statement()
{
  VALUE crocodile = rb_define_module("Crocodile");
  VALUE klass     = rb_define_class_under(crocodile, "Statement", rb_cObject);

  cCrocodileStatement = klass;
  cCrocodileRuleSet   = rb_define_class_under(crocodile, "RuleSet", klass);

  rb_define_method(klass, "statement_type", statement_type, 0);
  rb_define_method(klass, "parent_sheet", parent_sheet, 0);
  rb_define_method(klass, "specificity", specificity, 0);
  rb_define_method(klass, "line", line, 0);
  rb_define_method(klass, "column", column, 0);
  rb_define_method(klass, "byte", byte, 0);
}
