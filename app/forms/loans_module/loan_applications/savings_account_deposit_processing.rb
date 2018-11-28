module LoansModule
  module LoanApplications
    class SavingsAccountDepositProcessing
      include ActiveModel::Model
      attr_accessor :amount, :savings_account_id, :loan_application_id
      validates :amount, presence: true, numericality: true
      def process!
        ActiveRecord::Base.transaction do
          create_voucher_amount
        end
      end

      private
      def create_voucher_amount
        find_loan_application.voucher_amounts.create!(
        description: "Savings Deposit",
        amount: amount,
        account: find_savings_account.saving_product_account,
        commercial_document: find_savings_account,
        cooperative: find_loan_application.cooperative,
        amount_type: 'credit')
      end

      def find_loan_application
        LoansModule::LoanApplication.find(loan_application_id)
      end

      def find_savings_account
        MembershipsModule::Saving.find(savings_account_id)
      end
    end
  end
end