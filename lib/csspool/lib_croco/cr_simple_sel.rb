module CSSPool
  module LibCroco
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
        klass = CSSPool::Selectors::Simple

        case self[:type_mask]
        when 1      # UNIVERSAL_SELECTOR
          klass = CSSPool::Selectors::Universal
        when 1 << 1 # TYPE_SELECTOR
          klass = CSSPool::Selectors::Type
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
  end
end
