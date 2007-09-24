class CSS::SAC
  LexToken = Struct.new(:name, :pattern, :lex_pattern, :block)
  Token = Struct.new(:name, :value, :pos)
  
  class Token
    def to_yacc
      [self.name, self.value]
    end
  end
  
  class DelimToken < Token
    def to_yacc
      [self.value, self.value]
    end
  end  
end
