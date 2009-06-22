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
          1 => :divide,
          2 => :comma
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
        when 3  # TERM_STRING
          Crocodile::Terms::String.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string,
            unary_op,
            LibCroco.location_to_h(self)
          )
        when 4  # TERM_IDENT
          Crocodile::Terms::Ident.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string,
            operator,
            LibCroco.location_to_h(self)
          )
        when 5  # TERM_URI
        when 6  # TERM_RGB
        when 7  # TERM_UNICODERANGE
        when 8  # TERM_HASH
        end
      end
    end
  end
end
