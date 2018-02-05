module Suppliers
  class VoucherAmountProcessing
    include ActiveModel::Model
    attr_accessor :amount, :account_id, :description, :amount_type, :commercial_document_id

    validates :amount, presence: true, numericality: true
    validates :account_id, :amount_type, presence: true

    def process!
      ActiveRecord::Base.transaction do
        create_voucher_amounts
      end
    end

    private
    def create_voucher_amounts
      find_supplier.voucher_amounts.create(amount: amount, account_id: account_id, amount_type: amount_type)
    end
    def find_supplier
      Supplier.find_by_id(commercial_document_id)
    end
  end
end

