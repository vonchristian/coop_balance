module LoansModule
  module InterestChargeSetters
    class AddOn
      attr_reader :loan_application, :interest_config

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
        @loan_product     = @loan_application.loan_product
        @interest_config  = @loan_product.current_interest_config
      end

      def create_charge!
        create_add_on_interest
      end

      private

      def create_add_on_interest
        loan_application.voucher_amounts.credit.create!(
          cooperative: loan_application.cooperative,
          description: "Interest on Loan",
          amount: loan_application.add_on_interest,
          account: loan_application.interest_revenue_account
        )
      end
    end
  end
end
