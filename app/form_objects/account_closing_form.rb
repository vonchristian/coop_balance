class AccountClosingForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  attr_accessor :savings_account_id, :amount, :closing_account_fee, :reference_number, :date, :recorder_id
  validates :amount, presence: true, numericality: true
  validates :reference_number, presence: true
  validate :amount_less_than_current_cash_on_hand?
  validate :amount_is_less_than_balance?

  def save
    ActiveRecord::Base.transaction do
      save_withdraw
      close_account
    end
  end
  private

  def find_savings_account
    MembershipsModule::Saving.find_by_id(savings_account_id)
  end
  def find_employee
    User.find_by(id: recorder_id)
  end

  def save_withdraw
    find_savings_account.entries.create!(recorder_id: recorder_id, description: 'Closing of savings account', reference_number: reference_number, entry_date: date,
    debit_amounts_attributes: [{ account: debit_account, amount: find_savings_account.balance, commercial_document: find_savings_account }],
    credit_amounts_attributes: [{account: credit_account, amount: amount, commercial_document: find_savings_account}, { account: closing_fee_account, amount: closing_account_fee, commercial_document: find_savings_account }])
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
    find_savings_account.saving_product_account
  end

  def amount_is_less_than_balance?
    errors[:amount] << "Amount exceeded balance"  if BigDecimal.new(amount) > find_savings_account.balance
  end

  def amount_less_than_current_cash_on_hand?
    errors[:amount] << "Amount exceeded current cash on hand" if BigDecimal.new(amount) > find_employee.cash_on_hand_account_balance
  end
end
