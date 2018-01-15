module BankAccounts
  class EntryForm
    include ActiveModel::Model
    attr_accessor :bank_account_id, :description, :recorder_id, :amount, :or_number, :date
    validates  :amount, :description, presence: true
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
      find_bank_account.entries.create!(recorder_id: recorder_id,
      description: description, reference_number: or_number, entry_date: date,
      debit_amounts_attributes: [account_id: debit_account_id, amount: amount, commercial_document: find_bank_account],
      credit_amounts_attributes: [account_id: credit_account_id, amount: amount, commercial_document: find_bank_account])
    end
    def debit_account_id
      find_bank_account.account_id
    end
    def credit_account_id
      find_employee.cash_on_hand_account_id
    end
  end
end
