module LoansModule
  module LoanApplications
    class ProgramPayment
      include ActiveModel::Model
      attr_accessor :program_id, :loan_application_id, :amount

      validates :program_id, :loan_application_id, :amount, presence: true

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
        account:             find_program.account,
        commercial_document: find_subscription_for(find_program),
        cooperative:         find_loan_application.cooperative)
      end
      def find_loan_application
        LoansModule::LoanApplication.find(loan_application_id)
      end
      def find_subscription_for(program)
        borrower = find_loan_application.borrower
        borrower.program_subscriptions.find_or_create_by(program: program)
      end
      def find_program
        Cooperatives::Program.find(program_id)
      end
    end
  end
end
