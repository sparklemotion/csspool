module CSSPool
  module LibCroco
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
          CSSPool::Selectors::Class.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string
          )
        when 1 << 1 # PSEUDO_CLASS_ADD_SELECTOR
          pseudo = CRPseudo.new(self[:content])
          CSSPool::Selectors::PseudoClass.new(
            pseudo[:name].null? ? nil :
              LibCroco.cr_string_peek_raw_str(pseudo[:name]).read_string,
            pseudo[:extra].null? ? nil :
              LibCroco.cr_string_peek_raw_str(pseudo[:extra]).read_string
          )
        when 1 << 3 # ID_ADD_SELECTOR
          CSSPool::Selectors::Id.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string
          )
        when 1 << 4 # ATTRIBUTE_ADD_SELECTOR
          attr_sel = CRAttrSel.new(self[:content])
          raise "FIXME: additional add selectors" unless attr_sel[:next].null?
          CSSPool::Selectors::Attribute.new(
            attr_sel[:name].null? ? nil :
              LibCroco.cr_string_peek_raw_str(attr_sel[:name]).read_string,
            attr_sel[:value].null? ? nil :
              LibCroco.cr_string_peek_raw_str(attr_sel[:value]).read_string,
            attr_sel[:match_way]
          )
        end
      end
    end
  end
end
