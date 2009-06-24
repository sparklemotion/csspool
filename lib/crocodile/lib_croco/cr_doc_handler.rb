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
        :property,              :property,
        :start_font_face,       :start_font_face,
        :end_font_face,         :end_font_face,
        :start_media,           :start_media,
        :end_media,             :end_media
      )
    end
  end
end
