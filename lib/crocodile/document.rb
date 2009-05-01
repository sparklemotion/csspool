module Crocodile
  class Document
    def self.parse string_or_io, encoding = 'UTF-8'
      native_parse_mem(string_or_io, 5)
    end
  end
end
