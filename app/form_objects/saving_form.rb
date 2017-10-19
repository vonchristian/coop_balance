class SavingForm
  include ActiveModel::Model
  attr_accessor :depositor_id, :depositor_type, :saving_product_id, :account_number, :amount, :or_number, :date, :recorder_id
  validates :saving_product_id, presence: true

  def save
    ActiveRecord::Base.transaction do
      open_savings_account
      create_entry
    end
  end
  def find_depositor
    if Member.find_by(id: depositor_id).present?
      depositor = Member.Member.find_by(id: depositor_id)
    elsif User.find_by(id: depositor_id).present?
      depositor = User.find_by(id: depositor_id)
    end 
    depositor
  end
  def find_employee 
    User.find_by(id: recorder_id)
  end
  def open_savings_account
    find_depositor.savings.create(saving_product_id: saving_product_id, account_number: account_number)
  end
  def find_saving
    MembershipsModule::Saving.find_by(account_number: account_number, saving_product_id: saving_product_id)
  end
  def create_entry
    find_employee.entries.deposit.create!(commercial_document: find_saving, description: 'Savings deposit', reference_number: or_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def debit_account
    find_employee.cash_on_hand_account
  end
  def credit_account
    AccountingModule::Account.find_by(name: "Savings Deposits")
  end
end
