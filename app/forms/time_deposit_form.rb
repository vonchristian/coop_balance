class TimeDepositForm
  include ActiveModel::Model
  include ActiveModel::Callbacks
  attr_accessor :or_number, :account_number, :date_deposited, :amount,:membership_id, :recorder_id, :number_of_days, :time_deposit_product_id, :payment_type
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
    time_deposit = find_membership.time_deposits.create!(account_number: account_number, time_deposit_product_id: time_deposit_product_id)
    TimeDepositsModule::FixedTerm.create!(time_deposit: time_deposit, number_of_days: number_of_days, deposit_date: date_deposited, maturity_date: (date_deposited.to_date + (number_of_days.to_i.days)))
  end

  def find_membership
    Membership.find_by_id(membership_id)
  end
  def find_deposit
    MembershipsModule::TimeDeposit.find_by(account_number: account_number)
  end

  def find_employee
    User.find_by(id: recorder_id)
  end

  def create_entry
     find_deposit.entries.create!(payment_type: payment_type, recorder_id: recorder_id, description: 'Time deposit', reference_number: or_number, entry_date: date_deposited,
    debit_amounts_attributes: [account: find_employee.cash_on_hand_account, amount: amount, commercial_document: find_deposit],
    credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: find_deposit])
  end

  def credit_account
    find_deposit.time_deposit_product_account
  end
end