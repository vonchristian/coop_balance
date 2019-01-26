module LoansModule
  module InterestChargeSetters
    class Accrued
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
          commercial_document: loan_application,
          cooperative: loan_application.cooperative,
          description: "Accrued Interest Income",
          amount:     loan_application.add_on_interest,
          account:    interest_config.accrued_income_account
        )
      end
    end
  end
end
