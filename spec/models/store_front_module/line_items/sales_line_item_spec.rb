require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe SalesLineItem, type: :model do
      it_behaves_like 'a StoreFrontModule::LineItem subtype',
      kind: :sales_line_item

      describe 'associations' do
        it { is_expected.to belong_to :sales_order }
        it { is_expected.to have_many :referenced_purchase_line_items }
      end
      describe 'delegations' do
        it { is_expected.to delegate_method(:customer).to(:sales_order) }
        it { is_expected.to delegate_method(:official_receipt_number).to(:sales_order) }
        it { is_expected.to delegate_method(:date).to(:sales_order) }
        it { is_expected.to delegate_method(:customer_name).to(:sales_order) }
      end
      it ".cost_of_goods_sold" do
        purchase = create(:purchase_line_item, unit_cost: 5)
        sale = create(:sales_line_item, quantity: 100)
        another_sale = create(:sales_line_item, quantity: 20)
        reference = create(:referenced_purchase_line_item,
          purchase_line_item: purchase,
          sales_line_item: sale,
          unit_cost: 5,
          quantity: 100)
        reference_2 = create(:referenced_purchase_line_item,
          purchase_line_item: purchase,
          sales_line_item: another_sale,
          unit_cost: 5,
          quantity: 20)

        expect(described_class.cost_of_goods_sold).to eql 600

      end
      it "#cost_of_goods_sold" do
        purchase = create(:purchase_line_item, unit_cost: 5)
        sale = create(:sales_line_item, quantity: 100)
        reference = create(:referenced_purchase_line_item,
          purchase_line_item: purchase,
          sales_line_item: sale,
          unit_cost: 5,
          quantity: 100)

        expect(sale.cost_of_goods_sold).to eql 500
      end
    end
  end
end
