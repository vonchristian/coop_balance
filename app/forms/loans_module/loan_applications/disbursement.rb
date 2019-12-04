module LoansModule
  module LoanApplications
    class Disbursement
      include ActiveModel::Model
      attr_accessor :disbursement_date, :employee_id, :loan_application_id

      validates :disbursement_date, :loan_application_id, :employee_id, presence: true

      def disburse!
        if valid?
          ActiveRecord::Base.transaction do
            update_voucher_disbursement_date
            # create_loan
            # create_entry
            # update_entry_date
            # update_term
            # update_approved_at
            # update_last_transaction_date
          end
        end
      end

      private

      def update_voucher_disbursement_date
        find_loan_application.voucher.update!(disbursement_date: parsed_disbursement_date)
      end

      def find_loan_application
        LoansModule::LoanApplication.find(loan_application_id)
      end

      def find_employee
        User.find(employee_id)
      end



      def create_loan
        LoansModule::LoanCreationProcessing.new(
          loan_application: find_loan_application,
          employee:         find_employee).process!
      end
      #
      def create_entry
        LoansModule::LoanApplications::EntryProcessing.new(
        loan_application: find_loan_application,
        employee:         find_employee).process!
      end
      def update_last_transaction_date
          find_loan_application.loan.update!(last_transaction_date: disbursement_date)
          find_loan_application.loan.borrower.update!(last_transaction_date: disbursement_date)
      end

      def update_entry_date
        find_loan_application.voucher.entry.update(entry_date: disbursement_date)
      end

      def update_term
        find_loan_application.loan.current_term.update!(
          effectivity_date: disbursement_date,
          maturity_date: maturity_date)
      end

      def maturity_date
        parsed_disbursement_date +
        TermParser.new(term: find_loan_application.loan.term).add_months +
        TermParser.new(term: find_loan_application.loan.term).add_days
      end
      def parsed_disbursement_date
        if disbursement_date.kind_of?(Date) || disbursement_date.kind_of?(DateTime)
          disbursement_date
        else
          DateTime.parse(disbursement_date)
        end
      end
      def update_approved_at
        find_loan_application.update!(approved_at: parsed_disbursement_date)
      end
    end
  end
end
