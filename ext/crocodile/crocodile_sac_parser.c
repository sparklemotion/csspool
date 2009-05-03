#include <crocodile_sac_parser.h>

static void start_document(CRDocHandler *dh)
{
  VALUE document = (VALUE)dh->app_data;
  rb_funcall(document, rb_intern("start_document"), 0);
}

static void end_document(CRDocHandler *dh)
{
  VALUE document = (VALUE)dh->app_data;
  rb_funcall(document, rb_intern("end_document"), 0);
}

static VALUE parse_memory(VALUE self, VALUE string, VALUE encoding)
{
  CRParser * parser = cr_parser_new_from_buf(
      StringValuePtr(string),
      RSTRING_LEN(string),
      NUM2INT(encoding),
      FALSE
  );

  CRDocHandler * sac_handler = cr_doc_handler_new();

  sac_handler->app_data = (gpointer)rb_funcall(self, rb_intern("document"), 0);
  sac_handler->start_document = start_document;
  sac_handler->end_document = end_document;

  cr_parser_set_sac_handler(parser, sac_handler);
  cr_parser_parse(parser);
  cr_parser_destroy(parser);
  cr_doc_handler_destroy(sac_handler);
}

void init_crocodile_sac_parser()
{
  VALUE crocodile = rb_define_module("Crocodile");
  VALUE sac       = rb_define_module_under(crocodile, "SAC");
  VALUE klass     = rb_define_class_under(sac, "Parser", rb_cObject);

  rb_define_private_method(klass, "parse_memory", parse_memory, 2);
}
