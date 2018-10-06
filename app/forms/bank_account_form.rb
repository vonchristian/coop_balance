class BankAccountForm
  include ActiveModel::Model
  include ActiveModel::Callbacks
  attr_accessor :bank_name, :bank_address, :account_number,  :amount, :recorder_id, :account_id, :earned_interest_account_id, :date, :reference_number, :description

  validates :account_id, :earned_interest_account_id, presence: true

  def save
    ActiveRecord::Base.transaction do
      create_bank_account
    end
  end

  private
  def create_bank_account
    bank_account = BankAccount.find_or_create_by(bank_name: bank_name, bank_address: bank_address, account_number: account_number, account_id: account_id, earned_interest_account_id: earned_interest_account_id)
    bank_account.entries.create!(
      recorder: find_employee,
      entry_date: date, reference_number: reference_number, description: description,
      credit_amounts_attributes: [account: credit_account, amount: amount, commercial_document: bank_account],
      debit_amounts_attributes: [account_id: account_id, amount: amount, commercial_document: bank_account])
  end
  def find_employee
    User.find_by_id(recorder_id)
  end
  def credit_account
    find_employee.cash_on_hand_account
  end
end
