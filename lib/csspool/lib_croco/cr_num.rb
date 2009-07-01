module CSSPool
  module LibCroco
    class CRNum < FFI::Struct
      layout(
        :type,  :int,
        :value, :double,
        :line,        :int,
        :column,      :int,
        :byte_offset, :int
      )
    end
  end
end
