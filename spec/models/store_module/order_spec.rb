require 'rails_helper'

module StoreModule
  describe Order do
    context 'associations' do 
    	it { is_expected.to belong_to :member }
    	it { is_expected.to have_one :official_receipt }
    	it { is_expected.to have_many :line_items }
    end 
    context 'delegations' do 
    	it { is_expected.to delegate_method(:number).to(:official_receipt).with_prefix }
    end

    it { is_expected.to define_enum_for(:payment_type).with([:cash, :credit, :check])}
    it "#add_line_items_from_cart(cart)" do 
    	cart = create(:cart)
    	line_item = create(:line_item)
    	cart.add_line_item(line_item)
    	order = create(:order)
    	expect(order.line_items.count).to eql 0
    	
    	order.add_line_items_from_cart(cart)

    	expect(order.line_items.count).to eql 1
    end
  end 
end
