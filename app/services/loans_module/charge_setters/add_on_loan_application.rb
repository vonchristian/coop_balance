module LoansModule
  module ChargeSetters
    class AddOnLoanApplication
      attr_reader :loan, :loan_product

      def initialize(args)
        @loan         = args.fetch(:loan)
        @loan_product = @loan.loan_product
      end
      def create_charges!
        create_interest_on_loan_charge
        create_charges
        create_loan_protection_fund
      end

      private
      def create_interest_on_loan_charge
        loan.voucher_amounts.credit.create!(
          cooperative: loan.cooperative,
          description: "Interest on Loan (Add-on)",
          amount: loan.add_on_interest,
          account: loan_product.current_interest_config_unearned_interest_income_account
        )
      end

      def create_charges
        loan_product.loan_product_charges.each do |charge|
          loan.voucher_amounts.credit.create!(
            cooperative: loan.cooperative,
            description: charge.name,
            amount: charge.charge_amount(chargeable_amount: loan.loan_amount.amount),
            account: charge.account
          )
        end
      end

      def create_loan_protection_fund
        if loan_product.loan_protection_plan_provider.present?
          loan.voucher_amounts.credit.create!(
          cooperative: loan.cooperative,
          amount: loan_product.loan_protection_plan_provider.amount_for(loan),
          account: loan_product.loan_protection_plan_provider.accounts_payable,
          description: 'Loan Protection Fund'
          )
        end
      end
    end
  end
end
