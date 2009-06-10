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

      // if(add_sel->content.pseudo->type == FUNCTION_PSEUDO)
      //   klass = rb_const_get(mCrocodileSelectors, rb_intern("Function"));

      return rb_funcall(klass, rb_intern("new"), 2,
        add_sel->content.pseudo->name ?
          rb_str_new2(cr_string_peek_raw_str(add_sel->content.pseudo->name)) :
          Qnil,
        add_sel->content.pseudo->extra ?
          rb_str_new2(cr_string_peek_raw_str(add_sel->content.pseudo->extra)) :
          Qnil
      );
      break;
    case ID_ADD_SELECTOR:
      klass = rb_const_get(mCrocodileSelectors, rb_intern("Id"));
      return rb_funcall(klass, rb_intern("new"), 1,
        rb_str_new2(cr_string_peek_raw_str(add_sel->content.id_name))
      );
      break;
    case ATTRIBUTE_ADD_SELECTOR:
      klass = rb_const_get(mCrocodileSelectors, rb_intern("Attribute"));
      return rb_funcall(klass, rb_intern("new"), 3,
        add_sel->content.attr_sel->name ?
          rb_str_new2(cr_string_peek_raw_str(add_sel->content.attr_sel->name)) :
          Qnil,
        add_sel->content.attr_sel->value ?
          rb_str_new2(cr_string_peek_raw_str(add_sel->content.attr_sel->value)) :
          Qnil,
        INT2NUM(add_sel->content.attr_sel->match_way)
      );
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
  VALUE parser = (VALUE)dh->app_data;
  VALUE document = rb_funcall(parser, rb_intern("document"), 0);
  rb_funcall(document, rb_intern("start_document"), 0);
}

static void end_document(CRDocHandler *dh)
{
  VALUE parser = (VALUE)dh->app_data;
  VALUE document = rb_funcall(parser, rb_intern("document"), 0);
  rb_funcall(document, rb_intern("end_document"), 0);
}

static void charset(CRDocHandler *dh,
    CRString *name,
    CRParsingLocation *location)
{
  VALUE parser = (VALUE)dh->app_data;
  VALUE document = rb_funcall(parser, rb_intern("document"), 0);

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
  VALUE parser = (VALUE)dh->app_data;
  VALUE document = rb_funcall(parser, rb_intern("document"), 0);

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
  VALUE parser = (VALUE)dh->app_data;
  VALUE document = rb_funcall(parser, rb_intern("document"), 0);

  rb_funcall(document, rb_intern("comment"), 1,
    rb_str_new2(cr_string_peek_raw_str(string))
  );
}

static void start_selector(CRDocHandler *dh, CRSelector *list)
{
  VALUE parser = (VALUE)dh->app_data;
  VALUE document = rb_funcall(parser, rb_intern("document"), 0);
  VALUE selectors = rb_ary_new();

  CRSelector * sel = list;
  while(NULL != sel) {
    rb_ary_push(selectors, selector_to_rb(sel));
    sel = sel->next;
  }

  rb_funcall(parser, rb_intern("push"), 1, selectors);
  rb_funcall(document, rb_intern("start_selector"), 1, selectors);
}

static void end_selector(CRDocHandler *dh, CRSelector *list)
{
  VALUE parser = (VALUE)dh->app_data;
  VALUE document = rb_funcall(parser, rb_intern("document"), 0);
  VALUE selectors = rb_funcall(parser, rb_intern("pop"), 0);

  rb_funcall(document, rb_intern("end_selector"), 1, selectors);
}

static VALUE crnum_to_rb(CRNum *num)
{
}

static VALUE term_to_rb(CRTerm *expression)
{
  VALUE klass = Qnil;

  VALUE operator = Qnil;
  VALUE unary_operator = Qnil;

  switch(expression->the_operator) {
    case NO_OP:
      break;
    case DIVIDE:
      operator = ID2SYM(rb_intern("divide"));
      break;
    case COMMA:
      operator = ID2SYM(rb_intern("comma"));
      break;
  }

  switch(expression->unary_op) {
    case EMPTY_UNARY_UOP:
    case NO_UNARY_UOP:
      break;
    case PLUS_UOP:
      unary_operator = ID2SYM(rb_intern("plus"));
      break;
    case MINUS_UOP:
      unary_operator = ID2SYM(rb_intern("minus"));
      break;
  }


  switch(expression->type) {
    case TERM_IDENT:
      klass = rb_const_get(mCrocodileTerms, rb_intern("Ident"));
      return rb_funcall(klass, rb_intern("new"), 3,
        rb_str_new2(cr_string_peek_raw_str(expression->content.str)),
        operator,
        location_to_h(&expression->location)
      );
      break;
    case TERM_NUMBER:
      klass = rb_const_get(mCrocodileTerms, rb_intern("Number"));
      return rb_funcall(klass, rb_intern("new"), 3,
          crnum_to_rb(expression->content.num),
          unary_operator,
          location_to_h(&expression->location)
      );

    default:
      rb_raise(rb_eRuntimeError, "unknown type");
  }
  return Qnil;
}

static void property(CRDocHandler *dh,
    CRString *name,
    CRTerm *expression,
    gboolean important_eh)
{
  VALUE parser = (VALUE)dh->app_data;
  VALUE document = rb_funcall(parser, rb_intern("document"), 0);

  VALUE expressions = rb_ary_new();
  while(expression) {
    rb_ary_push(expressions, term_to_rb(expression));
    expression = expression->next;
  }

  rb_funcall(document, rb_intern("property"), 2,
    rb_str_new2(cr_string_peek_raw_str(name)),
    expressions
  );
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

  sac_handler->app_data = (gpointer)self;

  sac_handler->start_document = start_document;
  sac_handler->end_document = end_document;
  sac_handler->charset = charset;
  sac_handler->import_style = import_style;
  sac_handler->comment = css_comment;
  sac_handler->start_selector = start_selector;
  sac_handler->end_selector = end_selector;
  sac_handler->property = property;

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
