class SavingForm
  include ActiveModel::Model
  attr_accessor :member_id, :saving_product_id, :account_number, :amount, :or_number, :date
  validates :saving_product_id, presence: true

  def save
    ActiveRecord::Base.transaction do
      open_savings_account
      create_entry
    end
  end
  def find_member
    Member.find_by(id: member_id)
  end
  def open_savings_account
    find_member.savings.create(saving_product_id: saving_product_id, account_number: account_number)
  end
  def find_saving
    Saving.find_by(account_number: account_number, saving_product_id: saving_product_id)
  end
  def create_entry
    AccountingDepartment::Entry.create!(entry_type: 'deposit', commercial_document: find_saving, description: 'Savings deposit', reference_number: or_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def debit_account
    AccountingDepartment::Account.find_by(name: "Cash on Hand")
  end
  def credit_account
    AccountingDepartment::Account.find_by(name: "Savings")
  end
end
