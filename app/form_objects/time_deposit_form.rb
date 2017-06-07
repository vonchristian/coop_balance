class TimeDepositForm
  include ActiveModel::Model
  attr_accessor :or_number, :date, :amount, :account_number, :member_id

  def save
    ActiveRecord::Base.transaction do
      create_time_deposit
      create_entry
      set_product_for_time_deposit
    end
  end

  def create_time_deposit
    time_deposit = find_member.time_deposits.create(account_number: account_number)
  end
  def find_member
    Member.find_by(id: member_id)
  end
  def find_deposit
    TimeDeposit.find_by(account_number: account_number)
  end

  def create_entry
    AccountingDepartment::Entry.create!(entry_type: 'deposit', commercial_document: find_deposit, description: 'Time deposit', reference_number: or_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def debit_account
    AccountingDepartment::Account.find_by(name: "Cash on Hand")
  end
  def credit_account
    AccountingDepartment::Account.find_by(name: "Time Deposits Payable")
  end
  def set_product_for_time_deposit
    TimeDepositProduct.set_product_for(find_deposit)
  end
end
