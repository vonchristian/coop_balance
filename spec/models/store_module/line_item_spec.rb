require 'rails_helper'

module StoreModule
  describe LineItem do
    context 'associations' do 
    	it { is_expected.to belong_to :product }
    	it { is_expected.to belong_to :product_stock }
    	it { is_expected.to belong_to :cart }
    end 
    context 'delegations' do 
    	it { is_expected.to delegate_method(:name).to(:product_stock) }
    end

    it ".total_cost" do 
    	line_item = create(:line_item, total_cost: 10)
    	another_line_item = create(:line_item, total_cost: 10)

    	expect(StoreModule::LineItem.total_cost).to eql(20)
    end
  end
end
