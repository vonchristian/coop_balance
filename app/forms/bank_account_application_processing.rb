class BankAccountApplicationProcessing
  include ActiveModel::Model
  attr_accessor :bank_name, :bank_address, :account_number, :voucher_account_number, :account_id,
  :amount, :reference_number, :description, :date, :cooperative_id, :earned_interest_account_id

  def process!
    ActiveRecord::Base.transaction do
      create_bank_account
    end
  end
  def find_bank_account
    find_cooperative.bank_accounts.find_by(account_number: account_number)
  end

  private
  def create_bank_account
    BankAccount.create!(
      cooperative: find_cooperative,
      bank_name: bank_name,
      bank_address: bank_address,
      account_number: account_number,
      account_id: account_id,
      earned_interest_account_id: earned_interest_account_id
    )
  end
  def find_cooperative
    Cooperative.find(cooperative_id)
  end
end
