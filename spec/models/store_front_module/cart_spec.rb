require 'rails_helper'

module StoreFrontModule
	describe Cart do
	  context "associations" do
	  	it { is_expected.to belong_to :employee }
	  	it { is_expected.to have_many :line_items }
	  end

	  it "#total_cost" do
	  	cart = create(:cart)
	  	line_item = create(:line_item, cart: cart, total_cost: 10)
	  	another_line_item = create(:line_item, cart: cart, total_cost: 10)

	  	expect(cart.total_cost).to eq(20)
	  end
	end
end
