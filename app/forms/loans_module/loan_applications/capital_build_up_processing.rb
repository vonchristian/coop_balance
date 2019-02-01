module LoansModule
  module LoanApplications
    class CapitalBuildUpProcessing
      include ActiveModel::Model
      attr_accessor :amount, :loan_application_id, :share_capital_id, :employee_id
      validates :amount, numericality: true, presence: true
      def process!
        if valid?
          ActiveRecord::Base.transaction do
            save_loan_charge
          end
        end
      end

      private
      def save_loan_charge
        find_loan_application.voucher_amounts.create!(
        description:         "Capital Build Up",
        amount:              amount,
        account:             find_share_capital.share_capital_product_equity_account,
        commercial_document: find_share_capital,
        cooperative: find_loan_application.cooperative,
        amount_type: 'credit')
      end

      def find_loan_application
        LoansModule::LoanApplication.find(loan_application_id)
      end

      def find_share_capital
        MembershipsModule::ShareCapital.find(share_capital_id)
      end
    end
  end
end
