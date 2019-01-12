module LoansModule
  module InterestAmortizationCalculators
    class NumberOfPayments
      #calculate total prededucted interest by taking the first (n) number of payments
      #from the amortization schedule
      attr_reader :loan_application, :interest_prededuction
      def initialize(args)
        @loan_application         = args.fetch(:loan_application)
        @interest_prededuction    = args.fetch(:interest_prededuction)
      end

      def compute
        loan_application.amortization_schedules.order(date: :desc).
        first(interest_prededuction.number_of_payments).
        total_amortization
      end
    end
  end
end
