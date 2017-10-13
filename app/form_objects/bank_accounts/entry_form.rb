module BankAccounts
  class EntryForm
    include ActiveModel::Model
    attr_accessor :bank_account_id, :debit_account_id, :credit_account_id, :entry_type, :description, :recorder_id, :amount, :or_number, :date
    validates  :entry_type, :amount, :description, presence: true
    validates :amount, numericality: true
    def save
      ActiveRecord::Base.transaction do
        save_entry
      end
    end
    def find_bank_account
      BankAccount.find_by(id: bank_account_id)
    end
    def find_user 
      User.find_by(id: recorder_id)
    end

    def save_entry
      find_bank_account.entries.create!(recorder_id: recorder_id, entry_type: entry_type,  
      description: description, reference_number: or_number, entry_date: date,
      debit_amounts_attributes: [account_id: debit_account_id, amount: amount],
      credit_amounts_attributes: [account_id: credit_account_id, amount: amount])
    end
  end
end
