class DisbursementForm
  include ActiveModel::Model
  attr_accessor  :voucher_id, :voucherable_id, :amount, :reference_number, :date, :recorder_id
  validates :amount, presence: true, numericality: true
  validates :reference_number, presence: true

  def save
    ActiveRecord::Base.transaction do
      if find_voucher.for_loan?
        create_loan_disbursement
      end
    end
  end
  def find_voucher
    Voucher.find_by(id: voucher_id)
  end

  def find_loan
    LoansModule::Loan.find_by(id: voucherable_id)
  end
  def find_employee 
    User.find_by(id: recorder_id)
  end

  def create_loan_disbursement
    entry = AccountingModule::Entry.loan_disbursement.new(:description => "Loan disbursement", recorder_id: recorder_id, entry_date: date)
    loan_debit_amount = AccountingModule::DebitAmount.new(amount: find_loan.loan_amount, account: find_loan.loan_product_debit_account)
    loan_credit_amount = AccountingModule::CreditAmount.new(amount: find_loan.net_proceed, account:find_employee.cash_on_hand_account)
    entry.debit_amounts << loan_debit_amount
    entry.credit_amounts << loan_credit_amount
    find_loan.loan_charges.each do |loan_charge|
      credit_amount = AccountingModule::CreditAmount.new(account: loan_charge.credit_account, amount: loan_charge.amount)
      entry.credit_amounts << credit_amount
    end
    entry.save 
  end


  # #   accounts_receivable = Plutus::Asset.find_by_name('Accounts Receivable')
  # #
  # #   debit_amount = Plutus::DebitAmount.new(:account => cash, :amount => 1000)
  # #   credit_amount = Plutus::CreditAmount.new(:account => accounts_receivable, :amount => 1000)
  # #
  #   entry = AccountingModule::Entry.new(:description => "Loan disbursement")
  #   entry.debit_amounts << debit_amount
  #   entry.credit_amounts << credit_amount
  #   entry.save
  #   find_loan.loan_charges.each do |loan_charge| 
  #   AccountingModule::Entry.loan_disbursement.create!(recorder_id: recorder_id, commercial_document: find_loan, description: 'Loans disbursement', reference_number: reference_number, entry_date: date,
  #   debit_amounts_attributes: [ { account: find_employee.cash_on_hand_account, amount: loan_charge.amount}, {account: debit_account, amount: amount} ],
  #   credit_amounts_attributes: [ { account: loan_charge.credit_account, amount: loan_charge.amount}, {account: credit_account, amount: amount} ])
  #   end
  # end
  def credit_account
    find_employee.cash_on_hand_account
  end
  def debit_account
    find_loan.loan_product_debit_account
  end
end
