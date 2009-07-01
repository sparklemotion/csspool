module Crocodile
  module LibCroco
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
        simple_selectors = []
        pointer = self[:simple_sel]

        until pointer.null?
          LibCroco.cr_simple_sel_compute_specificity(pointer)
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
  end
end
