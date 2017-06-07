class WithdrawalForm
  include ActiveModel::Model
  attr_accessor :saving_id, :amount, :or_number, :date
  validates :amount, presence: true, numericality: true
  validates :or_number, presence: true

  def save
    ActiveRecord::Base.transaction do
      save_deposit
    end
  end
  def find_saving
    Saving.find_by(id: saving_id)
  end

  def save_deposit
    AccountingDepartment::Entry.create!(entry_type: 'withdrawal', commercial_document: find_saving, description: 'Savings deposit', reference_number: or_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def credit_account
    AccountingDepartment::Account.find_by(name: "Cash on Hand")
  end
  def debit_account
    AccountingDepartment::Account.find_by(name: "Savings")
  end
end
