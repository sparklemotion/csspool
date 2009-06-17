require 'ffi'

module Crocodile
  module LibCroco
    extend FFI::Library

    ffi_lib '/opt/local/lib/libcroco-0.6.3.dylib'

    attach_function :cr_doc_handler_new, [], :pointer
    attach_function :cr_parser_new_from_buf, [:string, :int, :int, :int], :pointer
    attach_function :cr_parser_set_sac_handler, [:pointer, :pointer], :int
    attach_function :cr_parser_parse, [:pointer], :int
    attach_function :cr_parser_destroy, [:pointer], :void
    attach_function :cr_doc_handler_destroy, [:pointer], :void
    attach_function :cr_string_peek_raw_str, [:pointer], :pointer

    callback :start_document, [:pointer], :void
    callback :end_document,   [:pointer], :void
    callback :charset,        [:pointer, :pointer, :pointer], :void
    callback :import_style,   [:pointer] * 5, :void
    callback :import_style_result,   [:pointer] * 5, :void
    callback :namespace_declaration, [:pointer] * 4, :void
    callback :comment, [:pointer, :pointer], :void
    callback :start_selector, [:pointer, :pointer], :void
    callback :end_selector, [:pointer, :pointer], :void
    callback :property, [:pointer] * 4, :void

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
