module BankAccounts
  class EntryForm
    include ActiveModel::Model
    attr_accessor :bank_account_id, :description, :recorder_id, :amount, :reference_number, :date, :debit_account_id, :credit_account_id
    validates  :amount, :description, :reference_number, :date, :debit_account_id, :credit_account_id, presence: true
    validates :amount, numericality: true
    def save
      ActiveRecord::Base.transaction do
        save_entry
      end
    end
    def find_bank_account
      BankAccount.find_by(id: bank_account_id)
    end
    def find_employee
      User.find_by(id: recorder_id)
    end

    def save_entry
      find_bank_account.entries.create!(
      recorder: find_employee,
      office: find_employee.office,
      cooperative: find_employee.cooperative,
      description: description, reference_number: reference_number, entry_date: date,
      debit_amounts_attributes: [account_id: debit_account_id, amount: amount, commercial_document: find_bank_account],
      credit_amounts_attributes: [account_id: credit_account_id, amount: amount, commercial_document: find_bank_account])
    end
    def find_employee
      User.find_by_id(recorder_id)
    end
  end
end
