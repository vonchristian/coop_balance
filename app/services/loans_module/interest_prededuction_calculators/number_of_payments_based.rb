module LoansModule
  module InterestPredeductionCalculators
    class NumberOfPaymentsBased
      attr_reader :interest_prededuction, :loan_application

      def initialize(args)
        @loan_application      = args.fetch(:loan_application)
        @loan_product          = @loan_application.loan_product
        @interest_prededuction = @loan_product.current_interest_prededuction
      end

      def calculate
        loan_application.
        amortization_schedules.
        by_oldest_date.
        first(interest_prededuction.number_of_payments).
        sum(&:interest)
      end
    end
  end
end
