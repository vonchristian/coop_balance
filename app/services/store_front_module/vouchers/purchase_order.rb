module StoreFrontModule
  module Vouchers
    class PurchaseOrder
      attr_reader :order, :employee, :supplier, :store_front

      def initialize(args)
        @order = args.fetch(:order)
        @employee = @order.employee
        @supplier = @order.supplier
        @store_front = @employee.store_front
      end

      def create_voucher
        voucher =  TreasuryModule.new(
          cooperative: order.cooperative,
          payee: order.supplier,
          office: employee.office,
          store_front: employee.store_front,
          preparer: employee,
          date: order.date,
          description: "Purchase order ##{order.reference_number}",
          reference_number: order.reference_number,
          account_number: SecureRandom.uuid
        )

        voucher.voucher_amounts.debit.build(
          amount: order.total_cost,
          account: store_front.merchandise_inventory_account,
          commercial_document: order
        )

        voucher.voucher_amounts.credit.build(
          amount: order.total_cost,
          account: supplier.payable_account,
          commercial_document: order
        )
        voucher.save!
      end
    end
  end
end
