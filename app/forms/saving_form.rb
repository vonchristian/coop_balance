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
    member_depositor = Member.find_by(id: depositor_id)
    employee_depositor = User.find_by_id(depositor_id)
    if member_depositor.present?
      member_depositor
    elsif employee_depositor.present?
      employee_depositor
    end
  end
  def open_savings_account
    savings_account = find_depositor.savings.create(
      saving_product_id: saving_product_id,
      account_number: account_number)
    AccountingModule::Entry.create!(
      commercial_document: find_depositor,
      recorder: find_employee,
      description: "Savings deposit  of #{find_depositor.name}",
      reference_number: or_number,
      entry_date: date,
    debit_amounts_attributes: [
      account: debit_account,
      amount: amount,
      commercial_document: savings_account],
    credit_amounts_attributes: [
      account: credit_account,
      amount: amount,
      commercial_document: savings_account])
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
