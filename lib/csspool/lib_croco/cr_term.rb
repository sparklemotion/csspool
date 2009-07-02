module CSSPool
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
          CSSPool::Terms::Number.new(
            num[:type],
            unary_op,
            num[:value],
            operator,
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
          CSSPool::Terms::Function.new(
            name,
            params.map { |param| param.to_term },
            operator,
            LibCroco.location_to_h(self)
          )
        when 3  # TERM_STRING
          CSSPool::Terms::String.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string,
            operator,
            LibCroco.location_to_h(self)
          )
        when 4  # TERM_IDENT
          CSSPool::Terms::Ident.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string,
            operator,
            LibCroco.location_to_h(self)
          )
        when 5  # TERM_URI
          CSSPool::Terms::URI.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string,
            operator,
            LibCroco.location_to_h(self)
          )
        when 6  # TERM_RGB
          rgb = LibCroco::CRRgb.new(self[:content])
          CSSPool::Terms::Rgb.new(
            rgb[:red],
            rgb[:green],
            rgb[:blue],
            rgb[:is_percentage] == 1,
            operator,
            LibCroco.location_to_h(rgb)
          )
        when 7  # TERM_UNICODERANGE
          raise "libcroco doesn't seem to support this term"
        when 8  # TERM_HASH
          CSSPool::Terms::Hash.new(
            LibCroco.cr_string_peek_raw_str(self[:content]).read_string,
            operator,
            LibCroco.location_to_h(self)
          )
        end
      end
    end
  end
end
