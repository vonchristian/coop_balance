module LoansModule
  module TotalRepaymentAmortizers
    class EqualPrincipal
      attr_reader :schedule

      def initialize(schedule:)
        @schedule = schedule
      end

      def amortized_total_repayment
        schedule.principal + applicable_interest
      end

      def applicable_interest
        if schedule.prededucted_interest?
          0
        else
          schedule.interest
        end
      end
    end
  end
end
