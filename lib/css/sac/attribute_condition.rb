module CSS
  module SAC
    class AttributeCondition < Condition
      attr_reader :local_name, :value, :specified
      alias :specified? :specified

      def initialize(attribute, conditions)
        @specified = false

        if attribute
          @condition_type = :SAC_ATTRIBUTE_CONDITION
          @local_name = attribute
        end

        if conditions
          @condition_type =
            case conditions.first
            when '~='
              :SAC_ONE_OF_ATTRIBUTE_CONDITION
            when '|='
              :SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION
            when '='
              :SAC_ATTRIBUTE_CONDITION
            end
          @value = conditions.last
          @specified = true
        end
      end
    end
  end
end
