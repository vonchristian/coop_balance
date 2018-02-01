require 'rails_helper'

module StoreFrontModule
  describe LineItem do
    describe 'associations' do
    	it { is_expected.to belong_to :commercial_document }
    	it { is_expected.to belong_to :cart }
      it { is_expected.to belong_to :order }
      it { is_expected.to belong_to :unit_of_measurement }
      it { is_expected.to belong_to :product }
      it { is_expected.to belong_to :referenced_line_item }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :unit_of_measurement_id }
      it { is_expected.to validate_presence_of :product_id }
    end


    describe 'delegations' do
    	it { is_expected.to delegate_method(:name).to(:commercial_document).with_prefix }
    end

    it ".total" do
      unit_of_measurement = create(:unit_of_measurement, base_measurement: true, quantity: 1)
      line_item = create(:line_item, unit_of_measurement: unit_of_measurement, quantity: 10)
      another_line_item = create(:line_item, unit_of_measurement: unit_of_measurement, quantity: 10)

      expect(StoreFrontModule::LineItem.total).to eql(20)
    end
    it '#cost_of_goods_sold' do
      product = create(:product)
      order = create(:purchase_order)
      purchase = create(:purchase_line_item_with_base_measurement,  quantity: 100, product: product, order: order)
      referenced_line_item = create(:line_item, unit_cost: 10)
      line_item = create(:sales_line_item_with_base_measurement, referenced_line_item: referenced_line_item, product: product, quantity: 5)

      expect(line_item.cost_of_goods_sold).to eql(50)
    end

    it ".total_cost" do
    	line_item = create(:line_item, total_cost: 10)
    	another_line_item = create(:line_item, total_cost: 10)

    	expect(StoreFrontModule::LineItem.total_cost).to eql(20)
    end
  end
end
