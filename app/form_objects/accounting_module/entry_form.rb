module AccountingModule 
  class EntryForm
    include ActiveModel::Model
    attr_accessor :user_id, :amount, :debit_account_id, :credit_account_id, :entry_type, :entry_date, :description, :reference_number
 
    validates :amount, presence: true, numericality: true
    validates :reference_number, :description, :debit_account_id, :credit_account_id, presence: true

    def save
      ActiveRecord::Base.transaction do
        save_deposit
      end
    end

  def save_deposit
    AccountingModule::Entry.create(recorder_id: user_id, entry_type: entry_type,  description: description, reference_number: reference_number, entry_date: entry_date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def debit_account
    AccountingModule::Account.find_by(name: "Cash on Hand")
  end
  def credit_account
    AccountingModule::Account.find_by(name: "Savings Deposits")
  end
  end 
end 