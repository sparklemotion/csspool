module CSSPool
  module LibCroco
    class CRParser < FFI::Struct
      layout(:priv, :pointer)

      #def self.release pointer
      #  CSSPool::LibCroco.cr_parser_destroy pointer
      #end
    end
  end
end
