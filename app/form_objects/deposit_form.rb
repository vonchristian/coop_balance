class DepositForm
  include ActiveModel::Model
  attr_accessor :saving_id, :recorder_id, :amount, :or_number, :date
  validates :amount, presence: true, numericality: true
  validates :or_number, presence: true

  def save
    ActiveRecord::Base.transaction do
      save_deposit
    end
  end
  def find_saving
    MembershipsModule::Saving.find_by(id: saving_id)
  end
  def find_user 
    User.find_by(id: recorder_id)
  end

  def save_deposit
    find_saving.entries.create!(recorder_id: recorder_id, entry_type: 'deposit',  description: 'Savings deposit', reference_number: or_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def debit_account
    if find_user.treasurer?
      AccountingModule::Account.find_by(name: "Cash on Hand (Treasury)")
    elsif find_user.teller?
      AccountingModule::Account.find_by(name: "Cash on Hand (Cashier)")
    end
  end
  def credit_account
    AccountingModule::Account.find_by(name: "Savings Deposits")
  end
end
