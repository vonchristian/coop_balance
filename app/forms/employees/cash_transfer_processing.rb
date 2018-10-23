
module Employees
  class CashTransferProcessing
    include ActiveModel::Model
    attr_accessor :date, :reference_number, :description, :amount, :employee_id, :transferred_to_id

    def save
      ActiveRecord::Base.transaction do
        save_cash_transfer
      end
    end

    private
    def save_cash_transfer
      entry = AccountingModule::Entry.create(
        entry_date: date,
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        reference_number: reference_number,
        description: description,
        commercial_document: find_employee,
        recorder: find_employee,
        credit_amounts_attributes: [
          amount: amount,
          account: find_employee.cash_on_hand_account,
          commercial_document: find_transferred_to
        ],
        debit_amounts_attributes: [
          amount: amount,
          account: find_transferred_to.cash_on_hand_account,
          commercial_document: find_transferred_to
        ]
      )
      entry.set_previous_entry!
      entry.set_hashes!
    end

    def find_employee
      User.find_by_id(employee_id)
    end
    def find_transferred_to
      User.find_by_id(transferred_to_id)
    end
    def interest_income_account
      find_loan.loan_product.interest_revenue_account
    end
    def interest_receivable_account
      find_loan.loan_product.interest_receivable_account
    end
  end
end
