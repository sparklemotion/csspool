module Crocodile
  module LibCroco
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
  end
end
