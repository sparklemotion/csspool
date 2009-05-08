#include <crocodile_sac_parser.h>

static VALUE location_to_h(CRParsingLocation * location)
{
  VALUE loc = rb_hash_new();
  rb_hash_aset(loc, ID2SYM(rb_intern("line")), INT2NUM(location->line));
  rb_hash_aset(loc, ID2SYM(rb_intern("column")), INT2NUM(location->column));
  rb_hash_aset(loc, ID2SYM(rb_intern("byte_offset")),
      INT2NUM(location->byte_offset));

  return loc;
}

static VALUE add_sel_to_rb(CRAdditionalSel * add_sel)
{
  VALUE klass = rb_const_get(mCrocodileSelectors, rb_intern("Additional"));

  switch(add_sel->type)
  {
    case CLASS_ADD_SELECTOR:
      klass = rb_const_get(mCrocodileSelectors, rb_intern("Class"));
      return rb_funcall(klass, rb_intern("new"), 1,
        rb_str_new2(cr_string_peek_raw_str(add_sel->content.class_name))
      );
      break;
    case PSEUDO_CLASS_ADD_SELECTOR:
      klass = rb_const_get(mCrocodileSelectors, rb_intern("PseudoClass"));
      break;
    case ID_ADD_SELECTOR:
      klass = rb_const_get(mCrocodileSelectors, rb_intern("Id"));
      break;
    case ATTRIBUTE_ADD_SELECTOR:
      klass = rb_const_get(mCrocodileSelectors, rb_intern("Attribute"));
      break;
    case NO_ADD_SELECTOR:
      break;
  }

  return rb_funcall(klass, rb_intern("new"), 0);
}

static VALUE simple_selector_to_rb(CRSimpleSel * simple_sel)
{
  VALUE klass = rb_const_get(mCrocodileSelectors, rb_intern("Simple"));

  switch(simple_sel->type_mask) {
    case UNIVERSAL_SELECTOR:
      klass = rb_const_get(mCrocodileSelectors, rb_intern("Universal"));
      break;
    case TYPE_SELECTOR:
      klass = rb_const_get(mCrocodileSelectors, rb_intern("Type"));
      break;
    case NO_SELECTOR_TYPE:
      break;
  }

  VALUE simple = rb_funcall(klass, rb_intern("new"), 2,
      simple_sel->name ?
        rb_str_new2(cr_string_peek_raw_str(simple_sel->name)) :
        Qnil,
      INT2NUM(simple_sel->combinator)
  );
  rb_funcall(simple, rb_intern("parse_location="), 1,
      location_to_h(&simple_sel->location));

  VALUE add_sel_list = rb_ary_new();

  // Copy our list of additional selectors
  CRAdditionalSel * add_sel = simple_sel->add_sel;
  while(NULL != add_sel) {
    rb_ary_push(add_sel_list, add_sel_to_rb(add_sel));
    add_sel = add_sel->next;
  }
  rb_funcall(simple, rb_intern("additional_selectors="), 1, add_sel_list);
  return simple;
}

static VALUE selector_to_rb(CRSelector * sel)
{
  VALUE klass = rb_const_get(mCrocodile, rb_intern("Selector"));

  VALUE simple_selectors = rb_ary_new();
  CRSimpleSel * simple_sel = sel->simple_sel;
  while(NULL != simple_sel) {
    rb_ary_push(simple_selectors, simple_selector_to_rb(simple_sel));
    simple_sel = simple_sel->next;
  }

  VALUE selector = rb_funcall(klass, rb_intern("new"), 2,
    simple_selectors,
    location_to_h(&sel->location)
  );

  return selector;
}

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

static void charset(CRDocHandler *dh,
    CRString *name,
    CRParsingLocation *location)
{
  VALUE document = (VALUE)dh->app_data;

  rb_funcall(document, rb_intern("charset"), 2,
    rb_str_new2(cr_string_peek_raw_str(name)),
    location_to_h(location)
  );
}

static void import_style(CRDocHandler *dh,
    GList *media_list,
    CRString *uri,
    CRString *default_ns,
    CRParsingLocation *location)
{
  VALUE document = (VALUE)dh->app_data;

  GList * list = media_list;
  VALUE mlist = rb_ary_new();
  while(list != NULL) {
    rb_ary_push(mlist,
        rb_str_new2(cr_string_peek_raw_str((CRString *)list->data)));
    list = list->next;
  }
  rb_funcall(document, rb_intern("import_style"), 4,
      mlist,
      uri ? rb_str_new2(cr_string_peek_raw_str(uri)) : Qnil,
      default_ns ? rb_str_new2(cr_string_peek_raw_str(default_ns)) : Qnil,
      location_to_h(location)
  );
}

static void css_comment(CRDocHandler *dh, CRString *string)
{
  VALUE document = (VALUE)dh->app_data;

  rb_funcall(document, rb_intern("comment"), 1,
    rb_str_new2(cr_string_peek_raw_str(string))
  );
}

static void start_selector(CRDocHandler *dh, CRSelector *list)
{
  VALUE document = (VALUE)dh->app_data;
  VALUE selectors = rb_ary_new();

  CRSelector * sel = list;
  while(NULL != sel) {
    rb_ary_push(selectors, selector_to_rb(sel));
    sel = sel->next;
  }
  rb_funcall(document, rb_intern("start_selector"), 1, selectors);
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
  sac_handler->charset = charset;
  sac_handler->import_style = import_style;
  sac_handler->comment = css_comment;
  sac_handler->start_selector = start_selector;

  cr_parser_set_sac_handler(parser, sac_handler);
  cr_parser_parse(parser);
  cr_parser_destroy(parser);
  cr_doc_handler_destroy(sac_handler);
  return self;
}

void init_crocodile_sac_parser()
{
  VALUE crocodile = rb_define_module("Crocodile");
  VALUE sac       = rb_define_module_under(crocodile, "SAC");
  VALUE klass     = rb_define_class_under(sac, "Parser", rb_cObject);

  rb_define_private_method(klass, "parse_memory", parse_memory, 2);
}
