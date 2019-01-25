module LoansModule
  module ChargeSetters
    class PercentBasedStraightLine
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
          amount_type: 'credit',
          cooperative: loan_application.cooperative,
          description: "Interest on Loan",
          amount:     computed_interest,
          account:     interest_config.interest_revenue_account
        )
      end

      def computed_interest
        total_interest_predeductible * interest_prededuction.rate
      end

      def total_interest_predeductible
        interest_config.compute_interest(loan_application.loan_amount)
      end
    end
  end
end
