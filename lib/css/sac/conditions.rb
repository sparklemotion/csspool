require "css/sac/conditions/condition"

%w(attribute begin_hyphen class combinator id one_of pseudo_class).each do |type|
  require "css/sac/conditions/#{type}_condition"
end
