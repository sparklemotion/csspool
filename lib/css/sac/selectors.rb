require "css/sac/selectors/selector"

%w(simple child conditional descendant element sibling).each do |type|
  require "css/sac/selectors/#{type}_selector"
end
