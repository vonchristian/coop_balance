module Vouchers
  class VoucherAmountProcessing
    include ActiveModel::Model
    attr_accessor :amount, :account_id, :description, :amount_type, :employee_id, :cash_account_id, :amount_type
    validates :amount, :account_id, presence: true
    validates :amount, numericality: true
    def save
      ActiveRecord::Base.transaction do
        create_voucher_amount
      end
    end
    private
    def create_voucher_amount
      Vouchers::VoucherAmount.create(
        cooperative: find_employee.cooperative,
        amount: amount,
        account_id: account_id,
        amount_type: set_amount_type(amount_type),
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
          recorder: find_employee,
          cooperative: find_employee.cooperative

          )
      else
        Vouchers::VoucherAmount.create(
          amount: amount,
          account: cash_account,
          amount_type: amount_type_contra,
          description: description,
          commercial_document: find_employee,
          recorder: find_employee,
          cooperative: find_employee.cooperative
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

    def find_account
      find_employee.cooperative.accounts.find(account_id)
    end

    def set_amount_type(amount_type)
      if find_account.is_a?(AccountingModule::Revenue)
        'credit'
      else
        amount_type
      end
    end
  end
end
