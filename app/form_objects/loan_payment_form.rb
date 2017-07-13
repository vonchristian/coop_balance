class LoanPaymentForm
  include ActiveModel::Model
  attr_accessor :loan_id, :amount, :reference_number, :date
  validates :amount, presence: true, numericality: true
  validates :reference_number, presence: true

  def save
    ActiveRecord::Base.transaction do
      save_payment
    end
  end
  def find_loan
    LoansModule::Loan.find_by(id: loan_id)
  end

  def save_payment
    AccountingModule::Entry.create!(entry_type: 'loan_payment', commercial_document: find_loan, description: 'Loans payment', reference_number: reference_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def credit_account
    AccountingModule::Account.find_by(name: "Loans Receivable - Current")
  end
  def debit_account
    AccountingModule::Account.find_by(name: "Cash on Hand")
  end
end
