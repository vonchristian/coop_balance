module LoansModule
  module InterestChargeSetters
    class Prededucted
      attr_reader :loan_application, :interest_config, :interest_prededuction

      def initialize(args)
        @loan_application      = args.fetch(:loan_application)
        @loan_product          = @loan_application.loan_product
        @interest_config       = @loan_product.current_interest_config
        @interest_prededuction = @loan_product.current_interest_prededuction
      end

      def create_charges!
        create_prededucted_interest
      end

      private
      def create_prededucted_interest
        loan_application.voucher_amounts.credit.create!(
          cooperative: loan_application.cooperative,
          description: "Interest on Loan",
          amount:     computed_interest,
          account:    interest_config.interest_revenue_account
        )
      end
      def computed_interest
        deductible_amount = loan_application.loan_amount * interest_config.rate
        interest_prededuction.calculate_prededucted_interest(deductible_amount)
      end
    end
  end
end
