#include <crocodile_document.h>

static void dealloc(CRStyleSheet * stylesheet)
{
  cr_stylesheet_destroy(stylesheet);
}

static VALUE native_parse_mem(VALUE klass, VALUE buffer, VALUE encoding)
{
  CRStyleSheet * stylesheet = NULL;
  enum CRStatus status = CR_OK;

  status = cr_om_parser_simply_parse_buf(
      StringValuePtr(buffer),
      RSTRING_LEN(buffer),
      NUM2INT(encoding),
      &stylesheet
  );

  if(status == CR_OK && stylesheet) {
    VALUE self = Data_Wrap_Struct(klass, NULL, dealloc, stylesheet);
    stylesheet->app_data = (void *)self;
    return self;
  }

  return Qnil;
}

VALUE statements(VALUE self)
{
  CRStyleSheet * stylesheet;
  Data_Get_Struct(self, CRStyleSheet, stylesheet);

  VALUE statements = rb_ary_new();
  CRStatement * statement = stylesheet->statements;
  while(NULL != statement) {
    rb_ary_push(statements, Crocodile_Wrap_Statement(statement));
    statement = statement->next;
  }
  return statements;
}

VALUE cCrocodileDocument;

void init_crocodile_document()
{
  VALUE crocodile = rb_define_module("Crocodile");
  VALUE klass     = rb_define_class_under(crocodile, "Document", rb_cObject);

  cCrocodileDocument = klass;

  rb_define_singleton_method(klass, "native_parse_mem", native_parse_mem, 2);

  rb_define_method(klass, "statements", statements, 0);
}
