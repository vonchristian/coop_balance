module LoansModule
  module LoanApplications
    class ProgramPayment
      include ActiveModel::Model
      attr_accessor :program_subscription_id, :loan_application_id, :amount

      validates :program_subscription_id, :loan_application_id, :amount, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_voucher_amount
        end
      end

      private

      def create_voucher_amount
        find_loan_application.voucher_amounts.credit.create!(
        description:         find_program.name,
        amount:              amount,
        account:             find_program_subscription.program_account,
        cooperative:         find_loan_application.cooperative)
      end
      def find_loan_application
        borrower.loan_applications.find(loan_application_id)
      end

      def find_program_subscription
        borrower.program_subscriptions.find(program_subscription_id)
      end
    end
  end
end
