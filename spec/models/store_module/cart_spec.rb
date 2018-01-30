require 'rails_helper'

module StoreFrontModule
	describe Cart do
	  context "associations" do
	  	it { is_expected.to belong_to :employee }
	  	it { is_expected.to have_many :line_items }
	  	it { is_expected.to have_many :product_stocks }
	  end

	  it "#total_cost" do
	  	cart = create(:cart)
	  	line_item = create(:line_item, cart: cart, total_cost: 10)
	  	another_line_item = create(:line_item, cart: cart, total_cost: 10)

	  	expect(cart.total_cost).to eq(20)
	  end

	  describe "#add_line_item(line_item)" do
	  	it "creates different line item if different product" do
	  		cart = create(:cart)
	  		product_stock = create(:product_stock)
	  		another_product_stock = create(:product_stock)
	  	  line_item = create(:line_item, total_cost: 10, line_itemable: product_stock)
	  	  another_line_item = create(:line_item, unit_cost: 30, quantity: 1, line_itemable: another_product_stock)
	  	  cart.add_line_item(line_item)
	  	  cart.add_line_item(another_line_item)


	  	  expect(cart.line_items.pluck(:line_itemable_id)).to include(line_item.line_itemable_id)
	  	  expect(cart.line_items.pluck(:line_itemable_id)).to include(another_line_item.line_itemable_id)
         expect(cart.line_items.count).to eql 2
	  	end
	  	it "replace with a single item if same product" do
	  		cart = create(:cart)
	  		product_stock = create(:product_stock)
	  	  line_item = create(:line_item, total_cost: 10, line_itemable: product_stock)
	  	  another_line_item = create(:line_item, unit_cost: 30, quantity: 1, line_itemable: product_stock)

	  	  cart.add_line_item(line_item)
	  	  expect(cart.line_items.pluck(:line_itemable_id)).to include(line_item.line_itemable_id)

	  	  cart.add_line_item(another_line_item)
	  	  expect(cart.line_items.pluck(:line_itemable_id)).to include(another_line_item.line_itemable_id)
         expect(cart.line_items.count).to eql 1
	  	end
	  end
	end
end
