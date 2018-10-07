class ProgramSubscriptionPaymentForm
  include ActiveModel::Model
  attr_accessor :program_subscription_id, :recorder_id, :amount, :reference_number, :date
  validates :amount, presence: true, numericality: true
  validates :reference_number, presence: true

  def save
    ActiveRecord::Base.transaction do
      save_payment
    end
  end
  def find_program_subscription
    ProgramSubscription.find_by(id: program_subscription_id)
  end

  def save_payment
    find_program_subscription.entries.create!(
      office: find_employee.office,
      cooperative: find_employee.cooperative,
      recorder_id: find_employee, description: 'Savings deposit', reference_number: reference_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def debit_account
    AccountingDepartment::Account.find_by(name: "Cash on Hand")
  end
  def credit_account
    AccountingDepartment::Account.find_by(name: "Members' Benefit and Other Funds Payable")
  end
  def find_employee
    User.find(recorder_id)
  end
end
