require 'ffi'

ENV['LIBCROCO'] ||= 'libcroco-0.6'

module CSSPool
  module LibCroco
    extend FFI::Library

    retry_times = 0

    retry_places = {
      0 => '/opt/local/lib/libcroco-0.6.dylib',
      1 => '/opt/local/lib/libcroco-0.6.so',
      2 => '/usr/local/lib/libcroco-0.6.dylib',
      3 => '/usr/local/lib/libcroco-0.6.so',
      4 => '/usr/lib/libcroco-0.6.dylib',
      5 => '/usr/lib/libcroco-0.6.so',
    }

    begin
      ffi_lib ENV['LIBCROCO']
    rescue LoadError => ex
      if retry_places.key?(retry_times)
        ENV['LIBCROCO'] = retry_places[retry_times]
        retry_times += 1
        retry
      end
      warn "### Please install libcroco"
      warn "### Set LD_LIBRARY_PATH *or* set LIBCROCO to point at libcroco-0.6.dylib"
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

require 'csspool/lib_croco/cr_doc_handler'
require 'csspool/lib_croco/cr_pseudo'
require 'csspool/lib_croco/cr_parsing_location'
require 'csspool/lib_croco/glist'
require 'csspool/lib_croco/cr_simple_sel'
require 'csspool/lib_croco/cr_selector'
require 'csspool/lib_croco/cr_additional_sel'
require 'csspool/lib_croco/cr_attr_sel'
require 'csspool/lib_croco/cr_term'
require 'csspool/lib_croco/cr_parser'
require 'csspool/lib_croco/cr_num'
require 'csspool/lib_croco/cr_rgb'
