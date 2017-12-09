class LoanPaymentForm
  include ActiveModel::Model
  attr_accessor :loan_id,
                :principal_amount,
                :interest_amount,
                :penalty_amount,
                :reference_number,
                :date,
                :recorder_id
  validates :principal_amount, :interest_amount, :penalty_amount, presence: true, numericality: true
  validates :reference_number, :principal_amount, presence: true
  validates :principal_amount, numericality: { greater_than: 0.01 }

  def save
    ActiveRecord::Base.transaction do
      save_payment
    end
  end
  def find_loan
    LoansModule::Loan.find_by(id: loan_id)
  end
  def find_employee
    User.find_by(id: recorder_id)
  end

  def save_payment
    interest_revenue_account = CoopConfigurationsModule::LoanInterestConfig.account_to_debit
    penalty_account = CoopConfigurationsModule::LoanPenaltyConfig.account_to_debit

    entry = AccountingModule::Entry.loan_payment.new(commercial_document: find_loan,  reference_number: reference_number, :description => "Payment of loan on #{Time.zone.now.strftime("%B %e, %Y")}", recorder_id: recorder_id, entry_date: date)
    interest_credit_amount = AccountingModule::CreditAmount.new(amount: interest_amount, account: interest_revenue_account)
    penalty_credit_amount = AccountingModule::CreditAmount.new(amount: penalty_amount, account: penalty_account)
    principal_credit_amount = AccountingModule::CreditAmount.new(amount: principal_amount, account: find_loan.loan_product_account)
    principal_debit_amount = AccountingModule::DebitAmount.new(amount: principal_amount, account: find_employee.cash_on_hand_account)
    interest_debit_amount = AccountingModule::DebitAmount.new(amount: interest_amount, account: find_employee.cash_on_hand_account)
    penalty_debit_amount = AccountingModule::DebitAmount.new(amount: penalty_amount, account: find_employee.cash_on_hand_account)
    entry.debit_amounts << principal_debit_amount
    if interest_amount > 0
      entry.debit_amounts << interest_debit_amount
    end
    if penalty_amount > 0
      entry.debit_amounts << penalty_debit_amount
    end

    entry.credit_amounts << interest_credit_amount
    entry.credit_amounts << penalty_credit_amount
    entry.credit_amounts << principal_credit_amount
    entry.save!
  end

  def debit_account
    find_employee.cash_on_hand_account
  end
end
