require 'rails_helper'

module StoreFrontModule
  module Vouchers
    describe CreditSalesOrder do
      it "create_voucher" do
        cooperative = create(:cooperative)
        origin_entry = create(:origin_entry, cooperative: cooperative)
        employee = create(:employee, cooperative: cooperative)
        order = create(:sales_order, employee: employee, credit: true)
        5.times do
          order.sales_line_items << create(:sales_line_item, quantity: 1, unit_cost: 10, total_cost: 10)
        end
        described_class.new(order: order).create_voucher

        expect(order.voucher.present?).to be true
      end
    end
  end
end
