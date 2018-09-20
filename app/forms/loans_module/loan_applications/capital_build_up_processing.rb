module LoansModule
  module LoanApplications
    class CapitalBuildUpProcessing
      include ActiveModel::Model
      attr_accessor :amount, :loan_application_id, :share_capital_id, :employee_id
      validates :amount, numericality: true, presence: true
      def process!
        ActiveRecord::Base.transaction do
          save_loan_charge
        end
      end

      private
      def save_loan_charge
        find_loan_application.voucher_amounts.create!(
        description: "Capital Build Up",
        amount: amount,
        account: find_share_capital.share_capital_product_paid_up_account,
        commercial_document: find_share_capital,
        amount_type: 'credit')
      end

      def find_loan_application
        LoansModule::LoanApplication.find(loan_application_id)
      end

      def find_share_capital
        MembershipsModule::ShareCapital.find_by_id(share_capital_id)
      end
    end
  end
end
