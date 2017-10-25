class AccountClosingForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  attr_accessor :savings_account_id, :amount, :closing_account_fee, :reference_number, :date, :recorder_id
  validates :amount, presence: true, numericality: true
  validates :reference_number, presence: true

  def save
    ActiveRecord::Base.transaction do
      if amount_is_less_than_balance
        save_withdraw
        close_account
      else
        errors[:base] << "Amount exceed balance"
      end
    end
  end
  def find_savings_account
    MembershipsModule::Saving.find_by(id: savings_account_id)
  end
  def find_employee
    User.find_by(id: recorder_id)
  end

  def save_withdraw
    find_savings_account.entries.withdrawal.create!(recorder_id: recorder_id, description: 'Closing of savings account', reference_number: reference_number, entry_date: date,
    debit_amounts_attributes: [{ account: debit_account, amount: amount }, { account: credit_account, amount: closing_account_fee}],
    credit_amounts_attributes: [{account: credit_account, amount: amount}, { account: closing_fee_account, amount: closing_account_fee }])
  end
  def close_account
    find_savings_account.closed!
  end

  def closing_fee_account
    AccountingModule::Account.find_by(name: "Closing Account Fees")
  end

  def credit_account
    find_employee.cash_on_hand_account
  end

  def debit_account
    AccountingModule::Account.find_by(name: "Savings Deposits")
  end

  def amount_is_less_than_balance
    amount.to_i <= find_savings_account.balance
  end
end
