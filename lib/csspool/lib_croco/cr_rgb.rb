module CSSPool
  module LibCroco
    class CRRgb < FFI::Struct
      layout(
        :name,          :string,
        :red,           :long,
        :green,         :long,
        :blue,          :long,
        :is_percentage, :int,
        :inherit,       :int,
        :is_transparent,:int,
        :line,          :int,
        :column,        :int,
        :byte_offset,   :int
      )
    end
  end
end
