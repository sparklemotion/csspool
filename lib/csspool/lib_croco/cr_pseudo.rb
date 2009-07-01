module CSSPool
  module LibCroco
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
  end
end
