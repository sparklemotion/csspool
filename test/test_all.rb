Dir[File.dirname(__FILE__) + "/test_*.rb"].
  reject  { |f| f == __FILE__ }.
  collect { |f| File.basename(f, ".rb") }.
  each    { |f| require f }
