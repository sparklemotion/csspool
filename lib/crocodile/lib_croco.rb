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
        :end_selector,          :end_selector,
        :property,              :property
      )
    end

    class CRPseudo < FFI::Struct
      layout(
        :pseudo_type, :int,
        :name,        :pointer,
        :extra,       :pointer,
        :line,        :int,
        :column,      :int,
        :byte_offset, :int
      )
    end

    class CRTerm < FFI::Struct
      layout(
        :type,        :int,
        :unary_op,    :int,
        :operator,    :int,
        :content,     :pointer,
        :ext_content, :pointer,
        :app_data,    :pointer,
        :ref_count,   :long,
        :next,        :pointer,
        :pref,        :pointer,
        :line,        :int,
        :column,      :int,
        :byte_offset, :int
      )

      def to_term
        operator = {
          0 => nil,
          1 => :divide,
          2 => :comma
        }[self[:operator]]

        unary_op = {
          0 => nil,
          1 => :plus,
          2 => :minus
        }[self[:unary_op]]

        case self[:type]
        when 0  # TERM_NO_TYPE
        when 1  # TERM_NUMBER
          Crocodile::Terms::Number.new(
            nil,
            unary_op,
            LibCroco.location_to_h(self)
          )
        when 2  # TERM_FUNCTION
        when 3  # TERM_STRING
        when 4  # TERM_IDENT
          Crocodile::Terms::Ident.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string,
            operator,
            LibCroco.location_to_h(self)
          )
        when 5  # TERM_URI
        when 6  # TERM_RGB
        when 7  # TERM_UNICODERANGE
        when 8  # TERM_HASH
        end
      end
    end

    class CRAttrSel < FFI::Struct
      layout(
        :name,        :pointer,
        :value,       :pointer,
        :match_way,   :int,
        :next,        :pointer,
        :prev,        :pointer,
        :line,        :int,
        :column,      :int,
        :byte_offset, :int
      )
    end

    class CRAdditionalSel < FFI::Struct
      layout(
        :sel_type,    :int,
        :content,     :pointer,
        :next,        :pointer,
        :prev,        :pointer,
        :line,        :int,
        :column,      :int,
        :byte_offset, :int
      )

      def to_additional_selector
        case self[:sel_type]
        when 1      # CLASS_ADD_SELECTOR
          Crocodile::Selectors::Class.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string
          )
        when 1 << 1 # PSEUDO_CLASS_ADD_SELECTOR
          pseudo = CRPseudo.new(self[:content])
          Crocodile::Selectors::PseudoClass.new(
            pseudo[:name].null? ? nil :
              LibCroco.cr_string_peek_raw_str(pseudo[:name]).read_string,
            pseudo[:extra].null? ? nil :
              LibCroco.cr_string_peek_raw_str(pseudo[:extra]).read_string
          )
        when 1 << 3 # ID_ADD_SELECTOR
          Crocodile::Selectors::Id.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string
          )
        when 1 << 4 # ATTRIBUTE_ADD_SELECTOR
          attr_sel = CRAttrSel.new(self[:content])
          Crocodile::Selectors::Attribute.new(
            attr_sel[:name].null? ? nil :
              LibCroco.cr_string_peek_raw_str(attr_sel[:name]).read_string,
            attr_sel[:value].null? ? nil :
              LibCroco.cr_string_peek_raw_str(attr_sel[:value]).read_string,
            attr_sel[:match_way]
          )
        end
      end
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

        additional_selectors = []
        pointer = self[:add_sel]
        until pointer.null?
          additional_selectors << CRAdditionalSel.new(pointer)
          pointer = additional_selectors.last[:next]
        end

        simple_sel.additional_selectors = additional_selectors.map { |as|
          as.to_additional_selector
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

    class Parser < FFI::Struct
      layout(:priv, :pointer)

      #def self.release pointer
      #  Crocodile::LibCroco.cr_parser_destroy pointer
      #end
    end
  end
end
