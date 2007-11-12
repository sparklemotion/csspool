module CSS
  module SAC
    class AttributeCondition < Condition
      attr_accessor :local_name, :value, :specified
      alias :specified? :specified

      class << self
        def pseudo_class_condition(pseudo_class)
          self.new do |condition|
            condition.condition_type = :SAC_PSEUDO_CLASS_CONDITION
            condition.value     = pseudo_class
          end
        end

        def attribute_id(id_value)
          self.new do |condition|
            condition.condition_type = :SAC_ID_CONDITION
            condition.specified = true
            condition.value     = id_value
          end
        end

        def class_condition(class_name)
          self.new do |condition|
            condition.condition_type = :SAC_CLASS_CONDITION
            condition.specified  = true
            condition.local_name = "class"
            condition.value      = class_name
          end
        end

        def attribute_condition(attribute, conditions)
          self.new do |condition|
            if attribute
              condition.condition_type = :SAC_ATTRIBUTE_CONDITION
              condition.local_name = attribute
            end

            if conditions
              condition.condition_type =
                case conditions.first
                when '~='
                  :SAC_ONE_OF_ATTRIBUTE_CONDITION
                when '|='
                  :SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION
                when '='
                  :SAC_ATTRIBUTE_CONDITION
                end
              condition.value = conditions.last
              condition.specified = true
            end
          end
        end
      end

      def initialize(attribute = nil, conditions = nil)
        @specified  = false
        @local_name = nil
        @value      = nil
        yield self if block_given?
      end

      def to_css
        case condition_type
        when :SAC_ONE_OF_ATTRIBUTE_CONDITION
          "[#{local_name}~=#{value}]"
        when :SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION
          "[#{local_name}|=#{value}]"
        when :SAC_ATTRIBUTE_CONDITION
          "[#{local_name}=#{value}]"
        when :SAC_CLASS_CONDITION
          ".#{value}"
        when :SAC_ID_CONDITION
          "#{value}"
        when :SAC_PSEUDO_CLASS_CONDITION
          ":#{value}"
        end
      end
      
      def to_xpath
        case condition_type
        when :SAC_ATTRIBUTE_CONDITION
          "[@#{local_name}#{value && "='#{value}'"}]"
        when :SAC_CLASS_CONDITION, :SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION, :SAC_ONE_OF_ATTRIBUTE_CONDITION
          "[contains(@#{local_name}, '#{value}')]"
        when :SAC_ID_CONDITION
          "[@id='#{value[1..value.size]}']"
        end
      end

      def specificity
        case condition_type
        when :SAC_ID_CONDITION
          100
        when :SAC_PSEUDO_CLASS_CONDITION
          0
        else
          10
        end
      end
    end
  end
end
