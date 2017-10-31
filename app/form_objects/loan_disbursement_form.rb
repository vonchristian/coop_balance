class LoanDisbursementForm
  include ActiveModel::Model
  attr_accessor :loan_id, :amount, :reference_number, :date, :recorder_id
  validates :amount, presence: true, numericality: true
  validates :reference_number, presence: true

  def save
    ActiveRecord::Base.transaction do
      save_disbursement
      # update_amortization_schedules
    end
  end
  def find_loan
    LoansModule::Loan.find_by(id: loan_id)
  end
  def find_employee
    User.find_by(id: recorder_id)
  end

  def save_disbursement
    find_loan.loan_charges.each do |loan_charge|
    AccountingModule::Entry.loan_disbursement.create!(recorder_id: recorder_id, commercial_document: find_loan, description: 'Loans disbursement', reference_number: reference_number, entry_date: date,
    debit_amounts_attributes: [ { account: find_employee.cash_on_hand_account, amount: loan_charge.amount}, {account: debit_account, amount: amount} ],
    credit_amounts_attributes: [ { account: loan_charge.credit_account, amount: loan_charge.amount}, {account: credit_account, amount: amount} ])
    end
  end
  def credit_account
    find_employee.cash_on_hand_account
  end
  def debit_account
    find_loan.loan_product_debit_account
  end
end
