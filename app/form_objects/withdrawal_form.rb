class WithdrawalForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  attr_accessor :saving_id, :amount, :or_number, :date, :recorder_id
  validates :amount, presence: true, numericality: true
  validates :or_number, presence: true

  def save
    ActiveRecord::Base.transaction do
      if amount_is_less_than_balance
        save_withdraw
      else 
        errors[:base] << "Amount exceed balance" 
      end
    end
  end
  def find_saving
    MembershipsModule::Saving.find_by(id: saving_id)
  end

  def save_withdraw
    find_saving.entries.create!(recorder_id: recorder_id, entry_type: 'withdrawal', description: 'Withdraw', reference_number: or_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def credit_account
    AccountingModule::Account.find_by(name: "Cash on Hand")
  end
  def debit_account
    AccountingModule::Account.find_by(name: "Savings Deposits")
  end

  def amount_is_less_than_balance
    amount.to_i < find_saving.balance
  end
end
