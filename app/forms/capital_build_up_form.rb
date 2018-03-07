class CapitalBuildUpForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  attr_accessor :or_number, :amount, :date, :share_capital_id, :recorder_id
  validates :amount, presence: true, numericality: true
  validates :or_number, presence: true
  def save
    ActiveRecord::Base.transaction do
      create_entry
    end
  end

  def find_share_capital
    MembershipsModule::ShareCapital.find_by_id(share_capital_id)
  end

  def create_entry
  AccountingModule::Entry.create!(
    commercial_document: find_subscriber,
    recorder_id: recorder_id,
    description: 'Payment of capital build up',
    reference_number: or_number,
    entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount, commercial_document: find_share_capital],
    credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: find_share_capital])
  end
  def debit_account
    find_employee.cash_on_hand_account
  end
  def credit_account
    find_share_capital.share_capital_product_paid_up_account
  end
  def find_subscriber
    find_share_capital.subscriber
  end
  def find_employee
    User.find_by_id(recorder_id)
  end
end
