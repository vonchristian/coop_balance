module LoansModule
  module Charges
    class CapitalBuildUp
      attr_reader :loan_application, :borrower, :share_capital, :share_capital_product, :loan_product

      def initialize(args={})
        @loan_application      = args.fetch(:loan_application)
        @loan_product          = @loan_application.loan_product
        @borrower              = @loan_application.borrower
        @share_capital         = @borrower.share_capitals.last
        @share_capital_product = @share_capital.share_capital_product
      end

      def create_capital_build_up
        if borrower.share_capitals.present? && loan_product.loan_product_charges.for_capital_build_up.present?
          loan_application.voucher_amounts.credit.create!(
            cooperative:         loan_application.cooperative,
            description:         "Capital Build Up",
            amount:              computed_amount,
            account:             share_capital.share_capital_equity_account
          )
        end
      end

      def computed_amount
        charge = loan_product.loan_product_charges.where(account: share_capital_product.equity_account).last
        charge.rate * loan_application.loan_amount.amount
      end
    end
  end
end
