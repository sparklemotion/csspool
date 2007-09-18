class CSS::SAC::DocumentHandler
  def initialize
  end

  # Receive notification of the beginning of a style sheet.
  def start_document(input_source)
  end

  # Receive notification of the end of a style sheet.
  def end_document(input_source)
  end

  # Receive notification of a comment
  def comment(text)
  end

  # Receive notification of an unknown at rule not supported by this parser.
  def ignorable_at_rule(at_rule)
  end

  def namespace_declaration(prefix, uri)
  end

  # Called on an import statement
  def import_style(uri, media, default_namespace_uri = nil)
  end

  # Notification of the start of a media statement
  def start_media(media)
  end

  # Notification of the end of a media statement
  def end_media(media)
  end

  # Notification of the start of a page statement
  def start_page(name = nil, pseudo_page = nil)
  end

  # Notification of the end of a page statement
  def end_page(name = nil, pseudo_page = nil)
  end

  # Notification of the beginning of a font face statement.
  def start_font_face
  end

  # Notification of the end of a font face statement.
  def end_font_face
  end

  # Notification of the beginning of a rule statement.
  def start_selector(selectors)
  end

  # Notification of the end of a rule statement.
  def end_selector(selectors)
  end

  # Notification of a declaration.
  def property(name, value, important)
  end
end
