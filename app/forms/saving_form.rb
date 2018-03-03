class SavingForm
  include ActiveModel::Model
  attr_accessor :depositor_id,  :saving_product_id, :account_number, :amount, :or_number, :date, :recorder_id
  validates :saving_product_id, presence: true
  validates :amount, presence: true, numericality: true
  validate :unique_saving_product_per_depositor
  def save
    ActiveRecord::Base.transaction do
      open_savings_account
    end
  end

  def find_employee
    User.find_by(id: recorder_id)
  end
  def find_depositor
    Membership.find_by(id: depositor_id)
  end
  def open_savings_account
    savings_account = MembershipsModule::Saving.create(membership_id: depositor_id, saving_product_id: saving_product_id, account_number: account_number)
    savings_account.entries.create!(recorder_id: recorder_id, description: 'Savings deposit', reference_number: or_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount, commercial_document: savings_account],
    credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: savings_account])
  end

  def debit_account
    find_employee.cash_on_hand_account
  end
  def credit_account
    find_savings_product.account
  end
  def find_savings_product
    CoopServicesModule::SavingProduct.find_by_id(saving_product_id)
  end
  private
  def unique_saving_product_per_depositor
    errors[:saving_product_id] << "Account already opened for this Saving Product" if find_depositor.savings.pluck(:saving_product_id).include?(saving_product_id)
  end
end
