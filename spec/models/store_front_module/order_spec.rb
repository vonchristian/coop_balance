require 'rails_helper'

module StoreFrontModule
  describe Order do
    describe 'associations' do
    	it { is_expected.to belong_to :commercial_document }
      it { is_expected.to belong_to :employee }
      it { is_expected.to belong_to :store_front }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :voucher }
    	it { is_expected.to have_one :official_receipt }
      it { is_expected.to have_one :invoice }
    	it { is_expected.to have_many :line_items }
      it { is_expected.to have_many :products }
    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:first_and_last_name).to(:commercial_document).with_prefix }
      it { is_expected.to delegate_method(:name).to(:commercial_document).with_prefix }

    	it { is_expected.to delegate_method(:number).to(:official_receipt).with_prefix }
      it { is_expected.to delegate_method(:number).to(:invoice).with_prefix }
    end

    it { is_expected.to define_enum_for(:pay_type).with([:cash, :check]) }
    describe ".ordered_on(options)" do
      it "with from date and to date" do
        order = create(:sales_order, date: Date.beginning_of_week)
        another_order = create(:sales_order, date: Date.today.end_of_week)
        third_order = create(:sales_order, date: Date.today.end_of_year)
        from_date = Date.today.beginning_of_week
        to_date = Date.today.end_of_week

        expect(described_class.ordered_on(from_date: from_date, to_date: to_date)).to include(order)
        expect(described_class.ordered_on(from_date: from_date, to_date: to_date)).to include(another_order)
        expect(described_class.ordered_on(from_date: from_date, to_date: to_date)).to_not include(third_order)
      end
      it "with no dates" do
        order = create(:sales_order, date: Date.beginning_of_week)
        another_order = create(:sales_order, date: Date.today.end_of_week)
        third_order = create(:sales_order, date: Date.today.end_of_year)
        from_date = Date.today.beginning_of_week
        to_date = Date.today.end_of_week

        expect(described_class.ordered_on).to include(order)
        expect(described_class.ordered_on).to include(another_order)
        expect(described_class.ordered_on).to include(third_order)
      end
    end
    describe '.total(options)' do
      it "with from date and to date" do
        order = create(:sales_order, date: Date.beginning_of_week)
        another_order = create(:sales_order, date: Date.today.end_of_week)
        third_order = create(:sales_order, date: Date.today.end_of_year)
        first_sales_line_item = create(:sales_line_item_with_base_measurement, total_cost: 500, order: order)
        second_sales_line_item = create(:sales_line_item_with_base_measurement, total_cost: 500, order: another_order)
        third_sales_line_item = create(:sales_line_item_with_base_measurement, total_cost: 500, order: third_order)


        from_date = Date.today.beginning_of_week
        to_date = Date.today.end_of_week

        expect(described_class.total(from_date: from_date, to_date: to_date)).to eql 1000

        expect(described_class.total).to eql 1500

      end
    end

    it '#cost_of_goods_sold' do
      product = create(:product)
      purchase_order = create(:order)
      sales_order = create(:order)
      purchase_line_item = create(:purchase_line_item_with_base_measurement, quantity: 100, unit_cost: 8, total_cost: 800, order: purchase_order, product: product)
      sales_line_item =  create(:sales_line_item_with_base_measurement, unit_cost: 10, total_cost: 1000,  quantity: 100,  order: sales_order, product: product)
      sales_line_item.referenced_purchase_line_items << create(:referenced_purchase_line_item, purchase_line_item: purchase_line_item, unit_cost: 8, quantity: 100 )
      expect(sales_order.cost_of_goods_sold).to eql(800)
      expect(sales_order.total_cost).to eql(1000)
    end
  end
end
