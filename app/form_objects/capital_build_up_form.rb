class CapitalBuildUpForm
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  attr_accessor :share_count, :or_number, :amount, :date, :share_capital_id, :recorder_id
  validates :amount, :share_count, presence: true, numericality: true
  validates :or_number, presence: true
  def save
    ActiveRecord::Base.transaction do
      create_entry
    end
  end
  def find_share_capital
    MembershipsModule::ShareCapital.find_by(id: share_capital_id)
  end

  def create_capital_build_up
    find_share_capital.capital_build_ups.create(share_count: share_count)
  end

  def create_entry
   find_share_capital.capital_build_ups.create!(recorder_id: recorder_id, description: 'Payment of capital build up', reference_number: or_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount, commercial_document: find_share_capital],
    credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: find_share_capital])
  end
  def debit_account
    User.find_by(id: recorder_id).cash_on_hand_account
  end
  def credit_account
    find_share_capital.share_capital_product_default_paid_up_account
  end
end
