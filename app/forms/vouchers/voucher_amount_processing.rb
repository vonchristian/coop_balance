module Vouchers
  class VoucherAmountProcessing
    include ActiveModel::Model
    attr_accessor :amount, :account_id, :description, :amount_type, :employee_id, :cash_account_id, :amount_type
    def save
      ActiveRecord::Base.transaction do
        create_voucher_amount
      end
    end
    private
    def create_voucher_amount
      Vouchers::VoucherAmount.create(
        amount: amount,
        account_id: account_id,
        amount_type: amount_type,
        description: description,
        commercial_document: find_employee,
        recorder: find_employee
        )
        if cash_account_id.present?
          create_cash_account_line_item
        end
    end
    def create_cash_account_line_item
      voucher_amounts = find_employee.voucher_amounts.where(account: cash_account)
      if voucher_amounts.present?
        voucher_amounts.destroy_all
        Vouchers::VoucherAmount.create(
          amount: find_employee.voucher_amounts.sum(&:amount),
          account: cash_account,
          amount_type: amount_type_contra,
          description: description,
          commercial_document: find_employee,
          recorder: find_employee
          )
      else
        Vouchers::VoucherAmount.create(
          amount: amount,
          account: cash_account,
          amount_type: amount_type_contra,
          description: description,
          commercial_document: find_employee,
          recorder: find_employee
          )
      end
    end

    def find_employee
      User.find(employee_id)
    end

    def cash_account
      find_employee.cash_accounts.find(cash_account_id)
    end

    def amount_type_contra
      if amount_type == 'credit'
        'debit'
      elsif amount_type == 'debit'
        'credit'
      end
    end
  end
end
