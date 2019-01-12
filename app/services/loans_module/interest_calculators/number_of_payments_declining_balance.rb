module LoansModule
  module InterestCalculators
    class NumberOfPaymentsDecliningBalance
      attr_reader :loan_application, :number_of_payments, :schedule, :loan_product

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
        @loan_product          = @loan_application.loan_product
        @interest_prededuction = @loan_product.current_interest_prededuction
        @number_of_payments    = @loan_product.current_interest_prededuction_number_of_payments
        @schedule              = args[:schedule]
      end

      def compute
        loan_application.amortization_schedules.by_oldest_date.first(number_of_payments).total_interest
      end

      def monthly_amortization_interest
        if loan_application.amortization_schedules.by_oldest_date.first == schedule
          loan_application.loan_amount * loan_product.monthly_interest_rate
        else
          loan_application.principal_balance_for(schedule) * loan_product.monthly_interest_rate
        end
      end
    end
  end
end
