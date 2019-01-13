module LoansModule
  module PredeductedInterestCalculators
    class NumberOfPaymentsDecliningBalance
      attr_reader :loan_application, :number_of_payments

      def initialize(args)
        @loan_application   = args.fetch(:loan_application)
        @loan_product       = @loan_application.loan_product
        @number_of_payments = @loan_product.current_interest_prededuction_number_of_payments
      end

      def prededucted_interest
        loan_application.amortization_schedules.by_oldest_date.first(number_of_payments).sum(&:interest)
      end
    end
  end
end
