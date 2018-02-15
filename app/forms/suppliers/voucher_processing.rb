module Suppliers
  class VoucherProcessing
    include ActiveModel::Model
    attr_accessor :number, :date, :supplier_id,  :description, :user_id, :number, :preparer_id
    validates :date, :description, presence: true
    def process!
      ActiveRecord::Base.transaction do
        create_voucher
      end
    end

    private
    def create_voucher
     voucher = find_supplier.vouchers.create(number: number,
                                    date: date,
                                    payee: find_supplier,
                                    description: description,
                                    preparer_id: preparer_id)
      voucher.voucher_amounts << find_supplier.voucher_amounts
    end
    def find_supplier
      Supplier.find_by_id(supplier_id)
    end
  end
end

