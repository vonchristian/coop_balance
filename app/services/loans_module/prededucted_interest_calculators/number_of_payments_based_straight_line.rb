module LoansModule
  module PredeductedInterestCalculators
    class NumberOfPaymentsBasedStraightLine
      attr_reader :loan_application, :interest_prededuction, :prededucted_number_of_payments

      def initialize(args)
        @loan_application      = args.fetch(:loan_application)
        @loan_product          = @loan_application.loan_product
        @interest_prededuction = @loan_product.current_interest_prededuction
        @prededucted_number_of_payments = @interest_prededuction.number_of_payments
      end

      def prededucted_interest
        loan_application.amortization_schedules.by_oldest_date.first(prededucted_number_of_payments).sum(&:interest)
      end
    end
  end
end
