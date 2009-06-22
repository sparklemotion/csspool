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
        list = []
        node = self
        until node.null?
          list << self[:data]
          node = node[:next]
        end
        list
      end
    end
  end
end
