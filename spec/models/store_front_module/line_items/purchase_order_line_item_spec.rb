require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe PurchaseOrderLineItem, type: :model do
      describe 'associations' do
        it { is_expected.to belong_to :purchase_order }
        it { is_expected.to have_many :sales_order_line_items }
      end
      describe 'delegations' do
        it { is_expected.to delegate_method(:supplier_name).to(:purchase_order) }
      end
      describe '.sold_quantity' do
        it 'not converted' do
          unit_of_measurement = create(:unit_of_measurement, base_measurement: true, quantity: 1)

          purchase_order_line_item = create(:purchase_order_line_item, quantity: 100, unit_of_measurement: unit_of_measurement)

          expect(purchase_order_line_item.available_quantity).to eql(100)

          sales_order_line_item = create(:sales_order_line_item, referenced_line_item: purchase_order_line_item, unit_of_measurement: unit_of_measurement, quantity: 10)

          expect(purchase_order_line_item.sold_quantity).to eql(10)
        end
        it 'is_converted' do
          unit_of_measurement = create(:unit_of_measurement, base_measurement: false, conversion_quantity: 10)

          purchase_order_line_item = create(:purchase_order_line_item, quantity: 500, unit_of_measurement: unit_of_measurement)
          expect(purchase_order_line_item.available_quantity).to eql(5000)

          sales_order_line_item = create(:sales_order_line_item, referenced_line_item: purchase_order_line_item, unit_of_measurement: unit_of_measurement, quantity: 10)

          expect(purchase_order_line_item.sold_quantity).to eql(100)
          expect(purchase_order_line_item.available_quantity).to eql(4_900)
        end
      end
      describe "#out_of_stock?" do
        it 'returns FALSE if quantity > 0' do
          unit_of_measurement = create(:unit_of_measurement, base_measurement: true, quantity: 1)
          purchase_order_line_item = create(:purchase_order_line_item, quantity: 100, unit_of_measurement: unit_of_measurement)

          expect(purchase_order_line_item.available_quantity).to eql(100)

          sales_order_line_item = create(:sales_order_line_item, referenced_line_item: purchase_order_line_item, unit_of_measurement: unit_of_measurement, quantity: 10)

          expect(purchase_order_line_item.out_of_stock?).to be false
        end
        it 'returns TRUE if quantity = 0' do
          unit_of_measurement = create(:unit_of_measurement, base_measurement: true, quantity: 1)
          purchase_order_line_item = create(:purchase_order_line_item, quantity: 100, unit_of_measurement: unit_of_measurement)

          expect(purchase_order_line_item.available_quantity).to eql(100)

          sales_order_line_item = create(:sales_order_line_item, referenced_line_item: purchase_order_line_item, unit_of_measurement: unit_of_measurement, quantity: 100)

          expect(purchase_order_line_item.out_of_stock?).to be true
        end
      end

      describe '.available_quantity' do
        it 'is not converted' do
          unit_of_measurement = create(:unit_of_measurement, base_measurement: true, quantity: 1)
          purchase_order_line_item = create(:purchase_order_line_item, quantity: 100, unit_of_measurement: unit_of_measurement)

          expect(purchase_order_line_item.available_quantity).to eql(100)

          sales_order_line_item = create(:sales_order_line_item, referenced_line_item: purchase_order_line_item, unit_of_measurement: unit_of_measurement, quantity: 10)

          expect(purchase_order_line_item.available_quantity).to eql(90)
        end
        it 'is_converted' do
          unit_of_measurement = create(:unit_of_measurement, base_measurement: false, conversion_quantity: 10)
          purchase_order_line_item = create(:purchase_order_line_item, quantity: 100, unit_of_measurement: unit_of_measurement)

          expect(purchase_order_line_item.available_quantity).to eql(1000)

          sales_order_line_item = create(:sales_order_line_item, referenced_line_item: purchase_order_line_item, unit_of_measurement: unit_of_measurement, quantity: 10)

          expect(purchase_order_line_item.sold_quantity).to eql(100)
          expect(purchase_order_line_item.available_quantity).to eql(900)
        end
      end

      it '#purchase_cost' do
        base_unit_of_measurement = create(:unit_of_measurement, base_measurement: true)
        regular_unit_of_measurement = create(:unit_of_measurement, base_measurement: false, conversion_quantity: 50)

        purchase_order_line_item = create(:purchase_order_line_item, unit_of_measurement: base_unit_of_measurement, unit_cost: 100)
        another_purchase_order_line_item = create(:purchase_order_line_item, unit_of_measurement: regular_unit_of_measurement, unit_cost: 500)

        expect(purchase_order_line_item.purchase_cost).to eql(100)
        expect(another_purchase_order_line_item.purchase_cost).to eql(10)
      end
    end
  end
end
