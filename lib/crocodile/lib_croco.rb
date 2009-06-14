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

    class CSSSACHandler < FFI::Struct
      layout(
        :priv,                  :pointer,
        :app_data,              :pointer,
        :start_document,        :start_document,
        :end_document,          :end_document,
        :charset,               :charset,
        :import_style,          :import_style,
        :import_style_result,   :import_style_result,
        :namespace_declaration, :namespace_declaration,
        :comment,               :comment,
        :start_selector,        :start_selector,
        :end_selector,          :end_selector
      )
    end

    class CRSimpleSel < FFI::Struct
      layout(
        :type_mask,       :int,
        :case_sensitive,  :int,
        :name,            :pointer,
        :combinator,      :int,
        :add_sel,         :pointer,
        :specificity,     :ulong,
        :next,            :pointer,
        :prev,            :pointer,
        :line,            :int,
        :column,          :int,
        :byte_offset,     :int
      )

      def to_simple_selector
        klass = Crocodile::Selectors::Simple

        case self[:type_mask]
        when 1      # UNIVERSAL_SELECTOR
          klass = Crocodile::Selectors::Universal
        when 1 << 1 # TYPE_SELECTOR
          klass = Crocodile::Selectors::Type
        end

        simple_sel = klass.new(
          self[:name].null? ? nil :
            LibCroco.cr_string_peek_raw_str(self[:name]).read_string,
          self[:combinator]
        )
        simple_sel.parse_location = {
          :line         => self[:line],
          :column       => self[:column],
          :byte_offset  => self[:byte_offset]
        }
        simple_sel
      end
    end

    class CRSelector < FFI::Struct
      layout(
        :simple_sel,    :pointer,
        :next,          :pointer,
        :prev,          :pointer,
        :line,          :int,
        :column,        :int,
        :byte_offset,   :int,
        :ref_count,     :long
      )

      def to_selector
        simple_selectors = [CRSimpleSel.new(self[:simple_sel])]
        pointer = simple_selectors.last[:next]
        until pointer.null?
          simple_selectors << CRSimpleSel.new(pointer)
          pointer = simple_selectors.last[:next]
        end

        simple_selectors = simple_selectors.map { |sel| sel.to_simple_selector }

        Selector.new simple_selectors, {
          :line         => self[:line],
          :column       => self[:column],
          :byte_offset  => self[:byte_offset]
        }
      end
    end

    class GList < FFI::Struct
      layout(
        :data,  :pointer,
        :next,  :pointer,
        :prev,  :pointer
      )

      def null?; false; end

      def to_a
        list = []
        node = self
        until node.null?
          list << self[:data]
          node = node[:next]
        end
        list
      end
    end

    class CRParsingLocation < FFI::Struct
      layout(
        :line,        :uint,
        :column,      :uint,
        :byte_offset, :uint
      )

      def to_h
        Hash[*[:line, :column, :byte_offset].map { |k|
          [k, self[k]]
        }.flatten]
      end
    end

    class Parser < FFI::ManagedStruct
      layout(:priv, :pointer)

      def self.release pointer
        Croc::LibCroco.cr_parser_destroy pointer
      end
    end
  end
end
