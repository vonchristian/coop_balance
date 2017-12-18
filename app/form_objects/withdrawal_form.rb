class WithdrawalForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  attr_accessor :saving_id, :amount, :or_number, :date, :recorder_id, :payment_type
  validates :amount, presence: true, numericality: true
  validates :or_number, presence: true
  validate :amount_less_than_current_cash_on_hand?
  validate :amount_is_less_than_balance?


  def save
    ActiveRecord::Base.transaction do
      save_withdraw
    end
  end
  def find_saving
    MembershipsModule::Saving.find_by(id: saving_id)
  end
  def find_employee
    User.find_by(id: recorder_id)
  end

  def save_withdraw
    find_saving.entries.create!(payment_type: payment_type, recorder_id: recorder_id, description: 'Withdraw', reference_number: or_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def credit_account
    find_employee.cash_on_hand_account
  end

  def debit_account
    find_saving.saving_product_account
    # AccountingModule::Account.find_by(name: "Savings Deposits")
  end

  private
  def amount_is_less_than_balance?
    errors[:amount] << "Amount exceeded balance"  if BigDecimal.new(amount) > find_saving.balance
  end

  def amount_less_than_current_cash_on_hand?
    errors[:amount] << "Amount exceeded current cash on hand" if BigDecimal.new(amount) > find_employee.cash_on_hand_account_balance
  end
end
