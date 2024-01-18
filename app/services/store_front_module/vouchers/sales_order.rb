module StoreFrontModule
  module Vouchers
    class SalesOrder
      attr_reader :order, :employee, :store_front

      def initialize(args)
        @order = args.fetch(:order)
        @employee = @order.employee
        @store_front = @employee.store_front
      end

      def create_voucher
        store_front = employee.store_front
        find_cash_account
        cost_of_goods_sold = store_front.cost_of_goods_sold_account
        store_front.sales_account
        store_front.sales_discount_account
        store_front.merchandise_inventory_account

        voucher = find_cooperative.vouchers.build(
          payee: order.customer,
          office: employee.office,
          preparer: employee,
          date: order.date,
          description: "Sales order ##{order.reference_number}",
          reference_number: order.reference_number,
          account_number: SecureRandom.uuid,
          commercial_document: order.customer
        )

        voucher.voucher_amounts.debit.build(
          amount: order.total_cost_less_discount,
          account: employee.cash_on_hand,
          commercial_document: order
        )
        voucher.voucher_amounts.debit.build(
          amount: order.discount_amount,
          account: store_front.sales_discount,
          commercial_document: order
        )
        voucher.voucher_amounts.debit.build(
          amount: order.cost_of_goods_sold,
          account: cost_of_goods_sold,
          commercial_document: order
        )

        voucher.voucher_amounts.credit.build(
          amount: order.total_cost,
          account: store_front.sales_account,
          commercial_document: order
        )

        voucher.voucher_amounts.credit.build(
          amount: order.cost_of_goods_sold,
          account: store_front.merchandise_inventory_account,
          commercial_document: order
        )

        voucher.save!
        order.update(voucher: voucher)
      end
    end
  end
end
