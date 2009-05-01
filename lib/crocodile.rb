require 'crocodile/document'
require 'crocodile/version'
require 'crocodile/crocodile'

def Crocodile string_or_io, encoding = 'UTF-8'
  Crocodile::Document.parse(string_or_io, encoding)
end
