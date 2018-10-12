module TreasuryModule
  class CashReceiptLineItemProcessing
    include ActiveModel::Model
    attr_accessor :amount, :account_id, :description, :amount_type, :employee_id, :cash_account_id
    def save
      ActiveRecord::Base.transaction do
        create_cash_receipt_line_item
      end
    end
    private
    def create_cash_receipt_line_item
      Vouchers::VoucherAmount.create(
        amount: amount,
        account_id: account_id,
        amount_type: 'credit',
        description: description,
        commercial_document: find_employee
        )
      create_cash_account_debit_line_item
    end
    def create_cash_account_debit_line_item
      voucher_amounts = find_employee.voucher_amounts.where(account: cash_account)
      if voucher_amounts.present?
        voucher_amounts.destroy_all
        Vouchers::VoucherAmount.create(
          amount: find_employee.voucher_amounts.sum(&:amount),
          account: cash_account,
          amount_type: 'debit',
          description: description,
          commercial_document: find_employee
          )
      else
        Vouchers::VoucherAmount.create(
          amount: amount,
          account: cash_account,
          amount_type: 'debit',
          description: description,
          commercial_document: find_employee
          )
      end
    end

    def find_employee
      User.find_by_id(employee_id)
    end
    def cash_account
      find_employee.cash_accounts.find(cash_account_id)
    end
  end
end
