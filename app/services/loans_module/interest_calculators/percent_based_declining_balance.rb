module LoansModule
  module InterestCalculators
    class PercentBasedDecliningBalance
        attr_reader :loan_application, :monthly_rate, :schedule
      def initialize(args)
        @loan_application = args.fetch(:loan_application)
        @schedule = args.fetch(:schedule)
        @monthly_rate = @loan_application.loan_product.current_interest_config_monthly_rate
      end

      def monthly_amortization_interest
        loan_application.principal_balance_for(schedule) * monthly_rate
      end
    end
  end
end
