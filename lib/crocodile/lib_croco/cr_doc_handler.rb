module Crocodile
  module LibCroco
    class CRDocHandler < FFI::Struct
      layout(
        :priv,                  :pointer,
        :app_data,              :pointer,
        :start_document,        :start_document,
        :end_document,          :end_document,
        :charset,               :charset,
        :import_style,          :import_style,
        :import_style_result,   :import_style_result,
        :namespace_declaration, :namespace_declaration,
        :comment,               :comment,
        :start_selector,        :start_selector,
        :end_selector,          :end_selector,
        :property,              :property
      )
    end
  end
end
