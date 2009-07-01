module CSSPool
  module LibCroco
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
  end
end
