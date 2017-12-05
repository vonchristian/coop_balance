require 'rails_helper'

module StoreModule
  describe LineItem do
    context 'associations' do
    	it { is_expected.to belong_to :line_itemable }
    	it { is_expected.to belong_to :cart }
    end

    context 'delegations' do
    	it { is_expected.to delegate_method(:name).to(:line_itemable).with_prefix }
      it { is_expected.to delegate_method(:barcode).to(:line_itemable).with_prefix }
    end

    it ".total_quantity" do
      line_item = create(:line_item, quantity: 10)
      another_line_item = create(:line_item, quantity: 10)

      expect(StoreModule::LineItem.total_quantity).to eql(20)
    end

    it ".total_cost" do
    	line_item = create(:line_item, total_cost: 10)
    	another_line_item = create(:line_item, total_cost: 10)

    	expect(StoreModule::LineItem.total_cost).to eql(20)
    end

    it '.set_total_cost' do
      line_item = create(:line_item, quantity: 1, unit_cost: 10)

      expect(line_item.unit_cost).to eql(10)
    end
  end
end
