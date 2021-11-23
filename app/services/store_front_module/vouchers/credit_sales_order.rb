module StoreFrontModule
  module Vouchers
    class CreditSalesOrder
      attr_reader :order, :store_front, :employee

      def initialize(args)
        @order       = args.fetch(:order)
        @store_front = @order.store_front
        @employee    = @order.employee
      end

      def create_voucher
        voucher = Voucher.new(
          cooperative:         employee.cooperative,
          payee:               order.customer,
          preparer:            employee,
          store_front:         store_front,
          description:         order.description,
          date:                order.date,
          office:              employee.office,
          commercial_document: order,
          reference_number:    order.reference_number,
          account_number:      SecureRandom.uuid
        )
        voucher.voucher_amounts.debit.build(
          amount:              order.total_cost,
          account:             store_front.accounts_receivable_account,
          commercial_document: order
        )

        voucher.voucher_amounts.debit.build(
          amount:              order.cost_of_goods_sold,
          account:             store_front.cost_of_goods_sold_account,
          commercial_document: order
        )

        voucher.voucher_amounts.credit.build(
          amount:              order.total_cost,
          account:             store_front.sales_account,
          commercial_document: order
        )

        voucher.voucher_amounts.credit.build(
          amount:              order.cost_of_goods_sold,
          account:             store_front.merchandise_inventory_account,
          commercial_document: order
        )
        voucher.save!
        order.update(voucher: voucher)
      end
    end
  end
end
