module Crocodile
  module LibCroco
    class CRTerm < FFI::Struct
      layout(
        :type,        :int,
        :unary_op,    :int,
        :operator,    :int,
        :content,     :pointer,
        :ext_content, :pointer,
        :app_data,    :pointer,
        :ref_count,   :long,
        :next,        :pointer,
        :pref,        :pointer,
        :line,        :int,
        :column,      :int,
        :byte_offset, :int
      )

      def to_term
        operator = {
          0 => nil,
          1 => '/',
          2 => ','
        }[self[:operator]]

        unary_op = {
          0 => nil,
          1 => :plus,
          2 => :minus
        }[self[:unary_op]]

        case self[:type]
        when 0  # TERM_NO_TYPE
        when 1  # TERM_NUMBER
          num = CRNum.new(self[:content])
          Crocodile::Terms::Number.new(
            num[:type],
            num[:value],
            unary_op,
            LibCroco.location_to_h(self)
          )
        when 2  # TERM_FUNCTION
          name = LibCroco.cr_string_peek_raw_str(self[:content]).read_string
          params = []
          term = self[:ext_content]
          until term.null?
            params << LibCroco::CRTerm.new(term)
            term = params.last[:next]
          end
          Crocodile::Terms::Function.new(
            name,
            params.map { |param| param.to_term },
            LibCroco.location_to_h(self)
          )
        when 3  # TERM_STRING
          Crocodile::Terms::String.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string,
            LibCroco.location_to_h(self)
          )
        when 4  # TERM_IDENT
          Crocodile::Terms::Ident.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string,
            operator,
            LibCroco.location_to_h(self)
          )
        when 5  # TERM_URI
          Crocodile::Terms::URI.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string,
            LibCroco.location_to_h(self)
          )
        when 6  # TERM_RGB
          LibCroco::CRRgb.new(self[:content]).to_rgb
        when 7  # TERM_UNICODERANGE
          raise "libcroco doesn't seem to support this term"
        when 8  # TERM_HASH
          Crocodile::Terms::Hash.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string,
            LibCroco.location_to_h(self)
          )
        end
      end
    end
  end
end
