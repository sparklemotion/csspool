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

      def to_rgb
        CSSPool::Terms::Rgb.new(
          self[:red],
          self[:green],
          self[:blue],
          self[:is_percentage] == 1,
          LibCroco.location_to_h(self)
        )
      end
    end
  end
end
