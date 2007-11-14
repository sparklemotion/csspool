require "css/sac/conditions"

module CSS
  module SAC
    module Conditions
      class AttributeCondition < Condition
        attr_accessor :local_name, :value, :specified
        alias :specified? :specified
        
        class << self
          def build(name, raw)
            condition, value = raw

            case condition
            when "~="
              OneOfCondition.new(name, value)
            when "|="
              BeginHyphenCondition.new(name, value)
            else
              AttributeCondition.new(name, value, true)
            end
          end
        end

        def initialize(local_name, value, specified, condition_type=:SAC_ATTRIBUTE_CONDITION)
          super(condition_type)
        
          @local_name = local_name
          @value = value
          @specified = specified
        end

        def to_css
          "[#{local_name}#{value && "=#{value}"}]"
        end
      
        def to_xpath
          "[@#{local_name}#{value && "='#{value}'"}]"
        end

        def specificity
          10
        end

        def ==(other)
          super && local_name == other.local_name && value == other.value &&
            specified == other.specified
        end
      end
    end
  end
end
