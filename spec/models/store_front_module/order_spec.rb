require 'rails_helper'

module StoreFrontModule
  describe Order do
    describe 'associations' do
    	it { is_expected.to belong_to :commercial_document }
      it { is_expected.to belong_to :employee }
    	it { is_expected.to have_one :official_receipt }
      it { is_expected.to have_one :invoice }
    	it { is_expected.to have_many :line_items }
      it { is_expected.to have_many :sales_line_items }
      it { is_expected.to have_many :purchase_line_items }
      it { is_expected.to have_many :sales_return_line_items }
      it { is_expected.to have_many :purchase_return_line_items }
      it { is_expected.to have_many :products }
    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:first_and_last_name).to(:commercial_document).with_prefix }
    	it { is_expected.to delegate_method(:number).to(:official_receipt).with_prefix }
      it { is_expected.to delegate_method(:number).to(:invoice).with_prefix }
    end
    it { is_expected.to define_enum_for(:pay_type).with([:cash, :credit, :check]) }
    it '#cost_of_goods_sold' do
      product = create(:product)
      purchase_order = create(:order)
      sales_order = create(:order)
      purchase_line_item = create(:purchase_line_item_with_base_measurement, quantity: 100, unit_cost: 8, total_cost: 800, order: purchase_order, product: product)
      sales_line_item =  create(:sales_line_item_with_base_measurement, unit_cost: 10, total_cost: 1000,  quantity: 100,  order: sales_order, product: product, referenced_line_item: purchase_line_item)

      expect(sales_order.cost_of_goods_sold).to eql(800)
      expect(sales_order.total_cost).to eql(1000)
    end
  end
end
