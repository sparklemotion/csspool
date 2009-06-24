module Crocodile
  module LibCroco
    class GList < FFI::Struct
      layout(
        :data,  :pointer,
        :next,  :pointer,
        :prev,  :pointer
      )

      def null?; false; end

      def to_a
        list = [self]
        pointer = list.last[:next]
        until pointer.null?
          list << GList.new(pointer)
          pointer = list.last[:next]
        end
        list.map { |x| x[:data] }
      end
    end
  end
end
