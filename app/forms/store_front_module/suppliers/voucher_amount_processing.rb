module StoreFrontModule
  module Suppliers
    class VoucherAmountProcessing
      include ActiveModel::Model
      attr_accessor :supplier_id, :amount,:account_id, :amount_type, :cooperative_id

      validates :amount, :account_id, :cooperative_id, :supplier_id, :amount_type, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_voucher_amount
        end
      end

      private
      def create_voucher_amount
        find_supplier.voucher_amounts.create(
          amount: amount,
          account_id: account_id,
          amount_type: amount_type
        )
      end

      def find_supplier
        find_cooperative.suppliers.find(supplier_id)
      end

      def find_cooperative
        Cooperative.find(cooperative_id)
      end
    end
  end
end
