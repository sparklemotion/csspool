module Crocodile
  module LibCroco
    class CRParser < FFI::Struct
      layout(:priv, :pointer)

      #def self.release pointer
      #  Crocodile::LibCroco.cr_parser_destroy pointer
      #end
    end
  end
end
