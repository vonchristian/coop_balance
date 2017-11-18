module Vouchers
  class LoanDisbursementForm
    include ActiveModel::Model
    attr_accessor  :voucher_id, :description, :voucherable_id, :amount, :reference_number, :date, :recorder_id
    validates :reference_number, :description, presence: true

    def save
      ActiveRecord::Base.transaction do
        create_loan_disbursement
        find_voucher.disbursed!
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
      entry = AccountingModule::Entry.loan_disbursement.new(voucher: find_voucher, commercial_document: find_loan, :description => description, recorder_id: recorder_id, entry_date: date)
      loan_debit_amount = AccountingModule::DebitAmount.new(amount: find_loan.loan_amount, account: find_loan.loan_product_account)
      loan_credit_amount = AccountingModule::CreditAmount.new(amount: find_loan.net_proceed, account:find_employee.cash_on_hand_account)
      entry.debit_amounts << loan_debit_amount
      entry.credit_amounts << loan_credit_amount
      find_loan.loan_charges.each do |loan_charge|
        credit_amount = AccountingModule::CreditAmount.new(account: loan_charge.account, amount: loan_charge.charge_amount_with_adjustment)
        entry.credit_amounts << credit_amount
      end
      entry.save!
      find_loan.disbursed!
    end

    def credit_account
      find_employee.cash_on_hand_account
    end
    def debit_account
      find_loan.loan_product_debit_account
    end
  end
end
