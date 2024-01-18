module LoansModule
  module InterestPredeductionCalculators
    class PercentBased
      attr_reader :interest_prededuction, :loan_application

      def initialize(args)
        @interest_prededuction = args.fetch(:interest_prededuction)
        @loan_application      = args.fetch(:loan_application)
      end

      def calculate
        deductible_interest_scope * interest_prededuction.rate
      end

      private

      def deductible_interest_scope
        if interest_prededuction.on_first_year?
          loan_application.first_year_interest
        else
          loan_application.total_interest
        end
      end
    end
  end
end
