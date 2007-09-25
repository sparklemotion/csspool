class CSS::SAC
  Token = Struct.new(:name, :value, :pos)
  
  class Token
    def to_yacc
      [name, value]
    end
  end
  
  class DelimToken < Token
    def to_yacc
      [value, value]
    end
  end  
end
