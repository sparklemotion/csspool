require 'ffi'

ENV['LIBCROCO'] ||= 'libcroco-0.6'

module Crocodile
  module LibCroco
    extend FFI::Library

    begin
      ffi_lib ENV['LIBCROCO']
    rescue LoadError => ex
      warn "### Please install libcroco and set LD_LIBRARY_PATH *or* set LIBCROCO to point at libcroco.dylib"
      raise ex
    end

    attach_function :cr_doc_handler_new, [], :pointer
    attach_function :cr_parser_new_from_buf, [:string, :int, :int, :int], :pointer
    attach_function :cr_parser_set_sac_handler, [:pointer, :pointer], :int
    attach_function :cr_parser_parse, [:pointer], :int
    attach_function :cr_parser_destroy, [:pointer], :void
    attach_function :cr_doc_handler_destroy, [:pointer], :void
    attach_function :cr_string_peek_raw_str, [:pointer], :pointer
    attach_function :cr_simple_sel_compute_specificity, [:pointer], :int

    callback :start_document, [:pointer], :void
    callback :end_document,   [:pointer], :void
    callback :charset,        [:pointer, :pointer, :pointer], :void
    callback :import_style,   [:pointer] * 5, :void
    callback :import_style_result,   [:pointer] * 5, :void
    callback :namespace_declaration, [:pointer] * 4, :void
    callback :comment, [:pointer, :pointer], :void
    callback :start_selector, [:pointer, :pointer], :void
    callback :end_selector, [:pointer, :pointer], :void
    callback :property, [:pointer, :pointer, :pointer, :int], :void
    callback :start_font_face, [:pointer] * 2, :void
    callback :end_font_face, [:pointer], :void
    callback :start_media, [:pointer] * 3, :void
    callback :end_media, [:pointer] * 2, :void

    def self.location_to_h thing
      {
        :line         => thing[:line],
        :column       => thing[:column],
        :byte_offset  => thing[:byte_offset]
      }
    end
  end
end

require 'crocodile/lib_croco/cr_doc_handler'
require 'crocodile/lib_croco/cr_pseudo'
require 'crocodile/lib_croco/cr_parsing_location'
require 'crocodile/lib_croco/glist'
require 'crocodile/lib_croco/cr_simple_sel'
require 'crocodile/lib_croco/cr_selector'
require 'crocodile/lib_croco/cr_additional_sel'
require 'crocodile/lib_croco/cr_attr_sel'
require 'crocodile/lib_croco/cr_term'
require 'crocodile/lib_croco/cr_parser'
require 'crocodile/lib_croco/cr_num'
require 'crocodile/lib_croco/cr_rgb'
