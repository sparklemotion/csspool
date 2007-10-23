module CSS
  module SAC
    class Condition
      attr_accessor :condition_type
    end

    class CombinatorCondition < Condition
      attr_accessor :first_condition, :second_condition

      def initialize(first, second)
        @first_condition = first
        @second_condition = second
      end
    end
  end
end
