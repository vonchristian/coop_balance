class CapitalBuildUpForm
  include ActiveModel::Model
  attr_accessor :share_count, :or_number, :amount, :date, :share_capital_id, :recorder_id

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
    AccountingModule::Entry.create!(entry_type: 'capital_build_up', recorder_id: recorder_id, commercial_document: find_share_capital, description: 'Payment of capital build up', reference_number: or_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
end
  def debit_account
    AccountingModule::Account.find_by(name: "Cash on Hand")
  end
  def credit_account
    AccountingModule::Account.find_by(name: "Paid-up Share Capital - Common")
  end
end
