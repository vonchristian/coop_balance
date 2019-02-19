module Merchants
  class PaymentLineItem
    include ActiveModel::Model
    attr_accessor :amount, :reference_number, :description, :employee_id, :commercial_document_id, :commercial_document_type, :merchant_id

    def process!
      create_voucher_amount
    end
    def create_voucher_amount
      Vouchers::VoucherAmount.credit.create!(
        reference_number: reference_number,
        amount: amount,
        description: description,
        account: find_merchant.liability_account,
        recorder: find_employee
      )
    end

    def find_merchant
      Merchant.find(merchant_id)
    end

    def find_employee
      User.find(employee_id)
    end
  end
end
