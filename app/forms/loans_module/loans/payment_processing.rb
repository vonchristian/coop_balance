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
                :employee_id
    validates :principal_amount, :interest_amount, :penalty_amount, presence: true, numericality: true
    validates :reference_number, presence: true

    def save
      ActiveRecord::Base.transaction do
        save_payment
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
      interest_revenue_account = find_loan.loan_product_interest_receivable_account
      penalty_account = find_loan.loan_product_penalty_receivable_account

      entry = AccountingModule::Entry.new(
        origin: find_employee.office,
        commercial_document: find_loan.borrower,
        reference_number: reference_number,
        :description => "Payment of loan on #{date.to_date.strftime("%B %e, %Y")}",
        recorder: find_employee,
        entry_date: date)
      interest_credit_amount = AccountingModule::CreditAmount.new(
        amount: interest_amount,
        account: interest_revenue_account,
        commercial_document: find_loan)
      penalty_credit_amount = AccountingModule::CreditAmount.new(
        amount: penalty_amount,
        account: penalty_account,
        commercial_document: find_loan)
      principal_credit_amount = AccountingModule::CreditAmount.new(
        amount: principal_amount,
        account: find_loan.loan_product_loans_receivable_current_account,
        commercial_document: find_loan)
      principal_debit_amount = AccountingModule::DebitAmount.new(
        amount: principal_amount,
        account: find_employee.cash_on_hand_account,
        commercial_document: find_loan)
      interest_debit_amount = AccountingModule::DebitAmount.new(
        amount: interest_amount,
        account: find_employee.cash_on_hand_account,
        commercial_document: find_loan)
      penalty_debit_amount = AccountingModule::DebitAmount.new(
        amount: penalty_amount,
        account: find_employee.cash_on_hand_account,
        commercial_document: find_loan)
      entry.debit_amounts << principal_debit_amount
      if interest_amount.to_f > 0
        entry.debit_amounts << interest_debit_amount
        entry.credit_amounts << interest_credit_amount
      end
      if penalty_amount.to_f > 0
        entry.debit_amounts << penalty_debit_amount
        entry.credit_amounts << penalty_credit_amount
      end
      entry.credit_amounts << principal_credit_amount
      entry.save!
    end

    def debit_account
      find_employee.cash_on_hand_account
    end
  end
end
end
