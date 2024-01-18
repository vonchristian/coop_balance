require 'rails_helper'

module StoreFrontModule
  module Vouchers
    describe OrderEntry do
      it '#create_entry' do
        cooperative = create(:cooperative)
        create(:origin_entry, cooperative: cooperative)
        employee = create(:employee, cooperative: cooperative)
        order = create(:sales_order, employee: employee, credit: true, cooperative: cooperative)
        5.times do
          order.sales_line_items << create(:sales_line_item, quantity: 1, unit_cost: 10, total_cost: 10)
        end

        StoreFrontModule::Vouchers::CreditSalesOrder.new(order: order).create_voucher
        described_class.new(voucher: order.voucher, order: order).create_entry

        expect(order.voucher.present?).to be true
      end
    end
  end
end
