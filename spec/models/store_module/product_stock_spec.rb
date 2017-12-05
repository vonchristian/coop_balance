require 'rails_helper'

  module StoreModule
  describe ProductStock do
    context "associations" do
    	it { is_expected.to belong_to :product }
    	it { is_expected.to belong_to :supplier }
      it { is_expected.to belong_to :registry }
      it { is_expected.to have_many :sold_items }
    end

    context 'validations' do
      it { is_expected.to validate_numericality_of :unit_cost }
      it { is_expected.to validate_numericality_of :total_cost }
      it { is_expected.to validate_numericality_of :quantity }
      it { is_expected.to validate_numericality_of :retail_price }
      it { is_expected.to validate_numericality_of :wholesale_price }
      it { is_expected.to validate_presence_of :supplier_id }
    end

    context 'delegations' do
    	it { is_expected.to delegate_method(:name).to(:product) }
    end

    it '.total_quantity' do
      product_stock = create(:product_stock, quantity: 10)
      product_stock_2 = create(:product_stock, quantity: 10)

      expect(StoreModule::ProductStock.total_quantity).to eql(20)
    end

    it '#in_stock' do
      product_stock = create(:product_stock, quantity: 20)
      sold_item = create(:line_item, quantity: 10, line_itemable: product_stock)

      expect(product_stock.in_stock).to eql(10)
    end

    it '#out_of_stock?' do
      product_stock = create(:product_stock, quantity: 20)
      sold_item = create(:line_item, quantity: 20, line_itemable: product_stock)

      expect(product_stock.out_of_stock?).to be true
    end

    it '#set_default_date' do
      product_stock = create(:product_stock)

      expect(product_stock.date.to_date).to eql(Time.zone.now.to_date)
    end

    it '#set_name' do
      product = create(:product, name: "Soy Sauce 250ml")
      product_stock = create(:product_stock, product: product)

      expect(product_stock.name).to eql("Soy Sauce 250ml")
    end
  end
end
