module LoansModule
  module LoanApplications
    class CapitalBuildUp < ActiveInteraction::Base
      object :loan_application, class: LoansModule::LoanApplication
      object :share_capital, class: DepositsModule::ShareCapital
      decimal :amount

      validates :amount, presence: true

      def execute
        create_voucher_amount
      end

      private

      def create_voucher_amount
        loan_application.voucher_amounts.where(
          description: "Capital Build Up",
          account: share_capital.share_capital_equity_account,
          cooperative: loan_application.cooperative,
          amount_type: "credit"
        ).first_or_create(amount: amount)
      end

      def share_capital
        @share_capital ||= DepositsModule::ShareCapital.find(share_capital_id)
      end
    end
  end
end
