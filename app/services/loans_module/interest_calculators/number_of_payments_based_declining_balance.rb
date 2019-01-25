module LoansModule
  module InterestCalculators
    class NumberOfPaymentsBasedDecliningBalance
      attr_reader :loan_application, :number_of_payments, :schedule, :loan_product

      def initialize(args)
        @loan_application      = args.fetch(:loan_application)
        @loan_product          = @loan_application.loan_product
        @interest_prededuction = @loan_product.current_interest_prededuction
        @number_of_payments    = @loan_product.current_interest_prededuction_number_of_payments
        @schedule              = args[:schedule]
      end

      def compute
        loan_application.amortization_schedules.by_oldest_date.first(number_of_payments).total_interest
      end

      def total_interest(args={})
        from_date = args.fetch(:from_date)
        to_date   = args.fetch(:to_date)
        loan_application.amortization_schedules.total_interest(from_date: from_date, to_date: to_date)
      end

      def monthly_amortization_interest
          principal_balance * loan_product.monthly_interest_rate
      end

      def principal_balance
        if loan_application.amortization_schedules.by_oldest_date.first == schedule
          loan_application.loan_amount.amount
        else
          loan_application.principal_balance_for(schedule.previous_schedule)
        end
      end
    end
  end
end
