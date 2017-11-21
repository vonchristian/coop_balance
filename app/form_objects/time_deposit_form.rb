class TimeDepositForm
  include ActiveModel::Model
  include ActiveModel::Callbacks
  attr_accessor :or_number, :account_number, :date_deposited, :amount,:member_id, :recorder_id, :number_of_days, :time_deposit_product_id
  validates :time_deposit_product_id, presence: true
  validates :amount, presence: true, numericality: true
  validates :number_of_days, presence: true, numericality: true

  def save
    ActiveRecord::Base.transaction do
      create_time_deposit
      create_entry
    end
  end
  def create_time_deposit
    time_deposit = find_member.time_deposits.create(account_number: account_number, time_deposit_product_id: time_deposit_product_id)
    time_deposit.fixed_terms.create(number_of_days: number_of_days, deposit_date: date_deposited, maturity_date: (date_deposited.to_date + (number_of_days.to_i.days)))
  end

  def find_member
    Member.find_by(id: member_id)
  end
  def find_deposit
    find_member.time_deposits.find_by(account_number: account_number)
  end

  def find_employee
    User.find_by(id: recorder_id)
  end

  def create_entry
    find_deposit.entries.time_deposit.create!(recorder_id: recorder_id, description: 'Time deposit', reference_number: or_number, entry_date: date_deposited,
    debit_amounts_attributes: [account: find_employee.cash_on_hand_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end

  def credit_account
    find_deposit.time_deposit_product_account
  end
end
