require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe PurchaseLineItem do
      describe 'associations' do
        it { is_expected.to belong_to :purchase_order }
        it { is_expected.to have_many :sales_purchase_line_items }
        it { is_expected.to have_many :purchase_returns }
        it { is_expected.to have_many :internal_uses }
        it { is_expected.to have_many :stock_transfers }
        it { is_expected.to have_many :sales_returns }
        it { is_expected.to have_many :spoilages }
        it { is_expected.to have_many :received_stock_transfers }
      end

      describe 'validations' do
        it { is_expected.to validate_presence_of :expiry_date }
      end
      describe 'delegations' do
        it { is_expected.to delegate_method(:supplier_name).to(:purchase_order) }
        it { is_expected.to delegate_method(:date).to(:purchase_order) }

      end
      describe '.sold_quantity' do
        it 'not converted' do
          base_unit_of_measurement = create(:unit_of_measurement,
                                            base_measurement: true,
                                            base_quantity: 1)
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
          not_base_unit_of_measurement = create(:unit_of_measurement,
                                                base_measurement: false,
                                                conversion_quantity: 10)
          purchase_line_item_2         = create(:purchase_line_item,
                                                quantity: 500,
                                                unit_of_measurement: not_base_unit_of_measurement)
          sales_line_item_2            = create(:sales_line_item,
                                                unit_of_measurement: not_base_unit_of_measurement,
                                                quantity: 10)
          referenced_2                 = create(:referenced_purchase_line_item,
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
                                            base_quantity: 1)
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
          unit_of_measurement_2 = create(:unit_of_measurement, base_measurement: true, base_quantity: 1)
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
                                            base_quantity: 1)
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
          referenced_2 =                  create(:sales_purchase_line_item,
                                                purchase_line_item: purchase_line_item_2,
                                                quantity: 10,
                                                sales_line_item: sales_line_item_2
                                                )
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

      it 'available_quantity' do
          purchase_line_item = create(:purchase_line_item_with_base_measurement, quantity: 1000)
          sales_purchase_line_item  = create(:sales_purchase_line_item,
                        quantity: 100,
                        purchase_line_item: purchase_line_item)
          sales_return = create(:sales_return_line_item_with_base_measurement,
                        purchase_line_item: purchase_line_item,
                        quantity: 50)
          spoilage = create(:spoilage_line_item_with_base_measurement,
                        purchase_line_item: purchase_line_item,
                        quantity: 50)
          received_stock_transfers = create(:received_stock_transfer_line_item_with_base_measurement,
                        purchase_line_item: purchase_line_item,
                        quantity: 50)
          internal_uses = create(:internal_use_line_item_with_base_measurement,
                        purchase_line_item: purchase_line_item,
                        quantity: 50)
          stock_transfers = create(:stock_transfer_line_item_with_base_measurement,
                        purchase_line_item: purchase_line_item,
                        quantity: 50)
           purchase_return = create(:purchase_return_line_item_with_base_measurement,
                        purchase_line_item: purchase_line_item,
                        quantity: 50)

          expect(purchase_line_item.converted_quantity).to eql 1_000
          expect(purchase_line_item.sales_returns_quantity).to eql 50
          expect(purchase_line_item.received_stock_transfers_quantity).to eql 50
          expect(purchase_line_item.sold_quantity).to eql 100
          expect(purchase_line_item.spoilages_quantity).to eql 50
          expect(purchase_line_item.internal_uses_quantity).to eql 50
          expect(purchase_line_item.stock_transfers_quantity).to eql 50
          expect(purchase_line_item.purchase_returns_quantity).to eql 50
          expect(purchase_line_item.available_quantity).to eql 800
      end

      it "#sold_quantity" do
        cooperative = create(:cooperative)
        product = create(:product, cooperative: cooperative)
        unit_of_measurement = create(:unit_of_measurement, base_measurement: true, base_quantity: 1)

        purchase_line_item = create(:purchase_line_item, product: product, quantity: 100, unit_cost: 1, total_cost: 100, unit_of_measurement: unit_of_measurement, cooperative: cooperative)
        purchase_order     = build(:purchase_order, cooperative: cooperative)
        purchase_voucher   = create(:voucher, cooperative: cooperative)
        origin_entry       = create(:origin_entry, cooperative: cooperative)
        purchase_entry = create(:entry_with_credit_and_debit, cooperative: cooperative)
        purchase_voucher.update_attributes(accounting_entry: purchase_entry)
        purchase_order.purchase_line_items << purchase_line_item
        purchase_order.update_attributes(voucher: purchase_voucher)
        purchase_order.save!

        sales_line_item = create(:sales_line_item, product: product, quantity: 100, unit_cost: 1, total_cost: 100, unit_of_measurement: unit_of_measurement, cooperative: cooperative)
        sales_order     = build(:sales_order, cooperative: cooperative)
        sales_entry     = create(:entry_with_credit_and_debit, cooperative: cooperative)
        sales_voucher   = build(:voucher, cooperative: cooperative)
        sales_voucher.update_attributes(accounting_entry: sales_entry)
        sales_voucher.save!
        sales_order.sales_line_items << sales_line_item
        sales_order.update_attributes(voucher: sales_voucher)
        sales_order.save!

        sales_purchase_line_item = create(:sales_purchase_line_item, purchase_line_item: purchase_line_item, sales_line_item: sales_line_item, quantity: 100)


        expect(sales_line_item.processed?).to be true

        expect(purchase_line_item.sold_quantity).to eql 100
      end
    end
  end
end
