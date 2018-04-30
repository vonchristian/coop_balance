module Vouchers
  class DisbursementProcessing
    include ActiveModel::Model
    attr_accessor :date, :reference_number, :description, :payee_id, :employee_id
    validates :date, :reference_number, :description, :payee_id, presence: true
    def disburse!
      ActiveRecord::Base.transaction do
        save_disbursement
      end
    end
    private
    def save_disbursement
      entry = AccountingModule::Entry.new(
        origin: find_employee.office,
        commercial_document: find_payee,
        :description => description,
        recorder: find_employee,
        reference_number: reference_number,
        entry_date: date)
      find_employee.voucher_amounts.debit.each do |amount|
        debit_amount = AccountingModule::DebitAmount.new(
          account_id: amount.account_id,
          amount: amount.amount,
          commercial_document: amount.commercial_document)
        entry.debit_amounts << debit_amount
      end
      find_employee.voucher_amounts.credit.each do |amount|
        credit_amount = AccountingModule::CreditAmount.new(
          account: amount.account,
          amount: amount.amount,
          commercial_document: amount.commercial_document)
        entry.credit_amounts << credit_amount
      end
      entry.save!
      find_employee.voucher_amounts.each do |amount|
        amount.commercial_document_id = nil
        amount.commercial_document_type = nil
        amount.save
      end
    end
    def credit_account_for(amount)
      if amount.account.name.downcase.include?("cash") || amount.account.name.downcase.include?("Cash")
        find_employee.cash_on_hand_account
      else
        amount.account
      end
    end

    def find_payee
     Payee.find_by_id(payee_id)
    end

    def find_employee
      User.find_by_id(employee_id)
    end
  end
end
