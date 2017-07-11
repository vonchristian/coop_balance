require 'rails_helper'

module StoreModule
	describe Cart do
	  context "associations" do 
	  	it { is_expected.to belong_to :employee }
	  	it { is_expected.to have_many :line_items }
	  	it { is_expected.to have_many :product_stocks }
	  end

	  it "#total_price" do 
	  	cart = create(:cart)
	  	line_item = create(:line_item, cart: cart, total_cost: 10)
	  	another_line_item = create(:line_item, cart: cart, total_cost: 10)

	  	expect(cart.total_price).to eq(20)
	  end

	  describe "#add_line_item(line_item)" do 
	  	it "replace with a single item if same product" do 
	  		cart = create(:cart)
	  		product_stock = create(:product_stock)
	  	  line_item = create(:line_item, total_cost: 10, product_stock: product_stock)
	  	  another_line_item = create(:line_item, unit_cost: 30, quantity: 1, product_stock: product_stock)

	  	  cart.add_line_item(line_item)
	  	  expect(cart.product_stocks).to include(line_item.product_stock)
	 
	  	  cart.add_line_item(another_line_item)
	  	  expect(cart.product_stocks).to include(another_line_item.product_stock)
	  	end
	  end
	end
end