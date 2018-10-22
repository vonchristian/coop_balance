module LoansModule
  module LoanApplications
    class VoucherAmountProcessing
      include ActiveModel::Model
      attr_accessor :amount, :account_id, :description, :loan_application_id

      def process!
        ActiveRecord::Base.transaction do
          create_voucher_amount
        end
      end

      private
      def create_voucher_amount
        Vouchers::VoucherAmount.create(
          commercial_document: find_loan_application,
          amount:              amount,
          account_id:          account_id,
          description:         description
        )
      end
      def find_loan_application
        LoanApplication.find(loan_application_id)
      end
    end
  end
end
