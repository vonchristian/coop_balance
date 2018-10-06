module LoansModule
  module Loans
    class PaymentProcessing
      include ActiveModel::Model
      attr_accessor :loan_id,
                :principal_amount,
                :interest_amount,
                :penalty_amount,
                :reference_number,
                :date,
                :description,
                :employee_id
      validates :principal_amount, :interest_amount, :penalty_amount, presence: true, numericality: true
      validates :reference_number, :description, presence: true

      def process!
        ActiveRecord::Base.transaction do
          save_payment
          update_last_transaction_date
        end
      end
      def find_loan
        LoansModule::Loan.find_by_id(loan_id)
      end
      def find_employee
        User.find_by_id(employee_id)
      end
      private
      def save_payment
        interest_revenue_account = find_loan.loan_product_interest_revenue_account
        penalty_revenue_account          = find_loan.loan_product_penalty_revenue_account
        debit_account            = find_employee.cash_on_hand_account
        entry = AccountingModule::Entry.new(
        commercial_document: find_loan,
        reference_number:    reference_number,
        description:         description,
        recorder:            find_employee,
        entry_date:          date)

        if interest_amount.to_f > 0
          entry.credit_amounts.build(
          amount:              interest_amount.to_f,
          account:             interest_revenue_account,
          commercial_document: find_loan)
        end
        if penalty_amount.to_f > 0
          entry.credit_amounts.build(
          amount:              penalty_amount.to_f,
          account:             penalty_revenue_account,
          commercial_document: find_loan)
        end
        if principal_amount.to_f > 0
          entry.credit_amounts.build(
          amount:              principal_amount.to_f,
          account:             find_loan.loan_product_loans_receivable_current_account,
          commercial_document: find_loan)
        end

        entry.debit_amounts.build(
        amount:              total_amount,
        account:             debit_account,
        commercial_document: find_loan)
        entry.save!
      end
      def total_amount
        principal_amount.to_f +
        interest_amount.to_f +
        penalty_amount.to_f
      end
      def update_last_transaction_date
        find_loan.update_attributes!(last_transaction_date: date)
      end
    end
  end
end
