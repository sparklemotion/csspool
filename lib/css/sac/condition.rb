module CSS
  module SAC
    class Condition
      attr_accessor :condition_type
    end

    class CombinatorCondition < Condition
      attr_accessor :first_condition, :second_condition

      def initialize(first, second, type = :SAC_AND_CONDITION)
        @first_condition = first
        @second_condition = second
        @condition_type = type
      end
    end
  end
end
