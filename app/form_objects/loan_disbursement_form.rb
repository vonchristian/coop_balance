class LoanDisbursementForm
  include ActiveModel::Model
  attr_accessor :loan_id, :amount, :reference_number, :date
  validates :amount, presence: true, numericality: true
  validates :reference_number, presence: true

  def save
    ActiveRecord::Base.transaction do
      save_disbursement
    end
  end
  def find_loan
    LoansDepartment::Loan.find_by(id: loan_id)
  end

  def save_disbursement
    AccountingDepartment::Entry.create!(entry_type: 'disbursement', commercial_document: find_loan, description: 'Savings deposit', reference_number: reference_number, entry_date: date,
    debit_amounts_attributes: [account: debit_account, amount: amount],
    credit_amounts_attributes: [account: credit_account, amount: amount])
  end
  def credit_account
    AccountingDepartment::Account.find_by(name: "Cash on Hand")
  end
  def debit_account
    AccountingDepartment::Account.find_by(name: "Loans Receivables")
  end
end