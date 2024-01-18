class BankAccountApplicationProcessing
  include ActiveModel::Model
  attr_accessor :bank_name, :bank_address, :account_number, :voucher_account_number, :cash_account_id,
                :amount, :reference_number, :description, :date, :cooperative_id, :interest_revenue_account_id, :office_id

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
      office: find_office,
      cooperative: find_cooperative,
      bank_name: bank_name,
      bank_address: bank_address,
      account_number: account_number,
      cash_account_id: cash_account_id,
      interest_revenue_account_id: interest_revenue_account_id
    )
  end

  def find_cooperative
    Cooperative.find(cooperative_id)
  end

  def find_office
    Cooperatives::Office.find(office_id)
  end
end
