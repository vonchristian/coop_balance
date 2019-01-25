module LoansModule
  module ChargeSetters
    class AddOnStraightLine
      attr_reader :loan_application, :loan_product

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
        @loan_product     = @loan_application.loan_product
      end

      def create_charges!
        create_accrued_interest
      end

      private
      def create_add_on_interest
        loan_application.voucher_amounts.credit.create!(
          cooperative: loan_application.cooperative,
          description: "Add-on Interest Income",
          amount:     loan_application.add_on_interest,
          account:    loan_product.current_interest_config_unearned_interest_income_account
        )
      end

      def create_charges
        loan_product.loan_product_charges.each do |charge|
          loan_application.voucher_amounts.credit.create!(
            cooperative: loan_application.cooperative,
            description: charge.name,
            amount: charge.charge_amount(chargeable_amount: loan_application.loan_amount.amount),
            account: charge.account
          )
        end
      end
    end
  end
end
