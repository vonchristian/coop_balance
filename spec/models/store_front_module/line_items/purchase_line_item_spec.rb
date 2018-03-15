require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe PurchaseLineItem, type: :model do
      describe 'associations' do
        it { is_expected.to belong_to :purchase_order }
        it { is_expected.to have_many :referenced_purchase_line_items }
      end
      describe 'delegations' do
        it { is_expected.to delegate_method(:supplier_name).to(:purchase_order) }
        it { is_expected.to delegate_method(:date).to(:purchase_order) }

      end
      describe '.sold_quantity' do
        it 'not converted' do
          base_unit_of_measurement = create(:unit_of_measurement,
                                            base_measurement: true,
                                            quantity: 1)
          purchase_line_item =       create(:purchase_line_item, quantity: 100,
                                            unit_of_measurement: base_unit_of_measurement)
          sales_line_item =          create(:sales_line_item,
                                            unit_of_measurement: base_unit_of_measurement,
                                            quantity: 10)
          referenced =               create(:referenced_purchase_line_item,
                                            purchase_line_item: purchase_line_item,
                                            quantity: 10,
                                            sales_line_item: sales_line_item,
                                            unit_of_measurement: base_unit_of_measurement)
          expect(purchase_line_item.sold_quantity). to eql 10
        end
        it 'is_converted' do
          not_base_unit_of_measurement =  create(:unit_of_measurement,
                                                base_measurement: false,
                                                conversion_quantity: 10)
          purchase_line_item_2 =          create(:purchase_line_item,
                                                quantity: 500,
                                                unit_of_measurement: not_base_unit_of_measurement)
          sales_line_item_2 =             create(:sales_line_item,
                                                unit_of_measurement: not_base_unit_of_measurement,
                                                quantity: 10)
          referenced_2 =                  create(:referenced_purchase_line_item,
                                                purchase_line_item: purchase_line_item_2,
                                                quantity: 10,
                                                sales_line_item: sales_line_item_2,
                                                unit_of_measurement: not_base_unit_of_measurement)
          expect(purchase_line_item_2.sold_quantity).to eql(100)
          expect(purchase_line_item_2.available_quantity).to eql(4_900)
        end
      end

      describe "#out_of_stock?" do
        it "returns FALSE if available quantity > 0" do
         base_unit_of_measurement = create(:unit_of_measurement,
                                            base_measurement: true,
                                            quantity: 1)
          purchase_line_item =       create(:purchase_line_item, quantity: 100,
                                            unit_of_measurement: base_unit_of_measurement)
          sales_line_item =          create(:sales_line_item,
                                            unit_of_measurement: base_unit_of_measurement,
                                            quantity: 10)
          referenced =               create(:referenced_purchase_line_item,
                                            purchase_line_item: purchase_line_item,
                                            quantity: 10,
                                            sales_line_item: sales_line_item,
                                            unit_of_measurement: base_unit_of_measurement)
          expect(purchase_line_item.sold_quantity). to eql 10
        end
        it 'returns TRUE if quantity = 0' do
          unit_of_measurement_2 = create(:unit_of_measurement, base_measurement: true, quantity: 1)
          purchase_line_item_2 = create(:purchase_line_item, quantity: 100, unit_of_measurement: unit_of_measurement_2)
          sales_line_item_2 = create(:sales_line_item, unit_of_measurement: unit_of_measurement_2, quantity: 100)
          referenced =                  create(:referenced_purchase_line_item,
                                                purchase_line_item: purchase_line_item_2,
                                                quantity: 100,
                                                sales_line_item: sales_line_item_2,
                                                unit_of_measurement: unit_of_measurement_2)
          expect(purchase_line_item_2.out_of_stock?).to be true
        end
      end

      describe "#available_quantity" do
        it "not_converted" do
         base_unit_of_measurement = create(:unit_of_measurement,
                                            base_measurement: true,
                                            quantity: 1)
          purchase_line_item =       create(:purchase_line_item, quantity: 100,
                                            unit_of_measurement: base_unit_of_measurement)
          sales_line_item =          create(:sales_line_item,
                                            unit_of_measurement: base_unit_of_measurement,
                                            quantity: 10)
          referenced =               create(:referenced_purchase_line_item,
                                            purchase_line_item: purchase_line_item,
                                            quantity: 10,
                                            sales_line_item: sales_line_item,
                                            unit_of_measurement: base_unit_of_measurement)
          expect(purchase_line_item.sold_quantity). to eql 10
          expect(purchase_line_item.available_quantity).to eql 90
        end
       it 'is_converted' do
          not_base_unit_of_measurement =  create(:unit_of_measurement,
                                                base_measurement: false,
                                                conversion_quantity: 10)
          purchase_line_item_2 =          create(:purchase_line_item,
                                                quantity: 500,
                                                unit_of_measurement: not_base_unit_of_measurement)
          sales_line_item_2 =             create(:sales_line_item,
                                                unit_of_measurement: not_base_unit_of_measurement,
                                                quantity: 10)
          referenced_2 =                  create(:referenced_purchase_line_item,
                                                purchase_line_item: purchase_line_item_2,
                                                quantity: 10,
                                                sales_line_item: sales_line_item_2,
                                                unit_of_measurement: not_base_unit_of_measurement)
          expect(purchase_line_item_2.sold_quantity).to eql(100)
          expect(purchase_line_item_2.available_quantity).to eql(4_900)
        end
      end

      it '#purchase_cost' do
        base_unit_of_measurement = create(:unit_of_measurement, base_measurement: true)
        regular_unit_of_measurement = create(:unit_of_measurement, base_measurement: false, conversion_quantity: 50)
        purchase_line_item = create(:purchase_line_item, unit_of_measurement: base_unit_of_measurement, unit_cost: 100)
        another_purchase_line_item = create(:purchase_line_item, unit_of_measurement: regular_unit_of_measurement, unit_cost: 500)

        expect(purchase_line_item.purchase_cost).to eql(100)
        expect(another_purchase_line_item.purchase_cost).to eql(10)
      end
    end
  end
end