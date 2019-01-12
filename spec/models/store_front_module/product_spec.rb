require 'rails_helper'

module StoreFrontModule
  describe Product do
    context "associations" do
      it { is_expected.to belong_to :store_front }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :stock_registry }
      it { is_expected.to belong_to :category }
    	it { is_expected.to have_many :unit_of_measurements }
      it { is_expected.to have_many :line_items }
      it { is_expected.to have_many :purchases }
      it { is_expected.to have_many :purchase_returns }
      it { is_expected.to have_many :sales }
      it { is_expected.to have_many :sales_returns }
      it { is_expected.to have_many :spoilages }
      it { is_expected.to have_many :internal_uses }
      it { is_expected.to have_many :stock_transfers }
      it { is_expected.to have_many :received_stock_transfers }
      it { is_expected.to have_many :orders }
      it { is_expected.to have_many :sales_orders }
      it { is_expected.to have_many :purchase_orders }
      it { is_expected.to have_many :purchase_return_orders }
      it { is_expected.to have_many :sales_return_orders }
      it { is_expected.to have_many :internal_use_orders }
      it { is_expected.to have_many :spoilage_orders }
      it { is_expected.to have_many :stock_transfer_orders }
      it { is_expected.to have_many :received_stock_transfer_orders }
    end
    describe 'validations' do
    	it { is_expected.to validate_presence_of :name }
    	it { is_expected.to validate_uniqueness_of :name }
    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:code).to(:base_measurement).with_prefix }
    end

    it { is_expected.to have_attached_file(:photo) }
    it { is_expected.to validate_attachment_content_type(:photo).
    	allowing('image/png', 'image/gif').
    	rejecting('text/plain', 'text/xml') }
    it { should validate_attachment_size(:photo).
      less_than(4.megabytes) }

    it "#base_measurement" do
      product = create(:product)
      unit_of_measurement = create(:unit_of_measurement, base_measurement: true, product: product)

      expect(product.base_measurement).to eql(unit_of_measurement)
    end

      describe "#out_of_stock?" do
        it "returns TRUE if available_quantity == 0" do
          product = create(:product)
          purchase_order = create(:purchase_order)
          sales_order = create(:sales_order)
          purchase = create(:purchase_line_item_with_base_measurement,  quantity: 100, product: product, order: purchase_order)
          sale = create(:sales_line_item_with_base_measurement,  quantity: 100.0, product: product, order: sales_order)

          expect(product.sales_balance).to eql(100)
          expect(product.balance).to eql(0)
          expect(product.out_of_stock?).to be true

          sales_return = create(:sales_return_line_item_with_base_measurement,  quantity: 10.0, product: product, order: sales_order)

          expect(product.sales_returns_balance).to eql(10)
          expect(product.balance).to eql(10)
          expect(product.out_of_stock?).to be false
        end
      end
      it 'balance' do
          product = create(:product)
          purchase = create(:purchase_line_item_with_base_measurement,
                        product: product,
                        quantity: 1000)
          sales = create(:sales_line_item_with_base_measurement,
                        product: product,
                        quantity: 100)
          sales_return = create(:sales_return_line_item_with_base_measurement,
                        product: product,
                        quantity: 50)
          spoilage = create(:spoilage_line_item_with_base_measurement,
                        product: product,
                        quantity: 50)
          received_stock_transfers = create(:received_stock_transfer_line_item_with_base_measurement,
                        product: product,
                        quantity: 50)
          internal_uses = create(:internal_use_line_item_with_base_measurement,
                        product: product,
                        quantity: 50)
          stock_transfers = create(:stock_transfer_line_item_with_base_measurement,
                        product: product,
                        quantity: 50)
           purchase_return = create(:purchase_return_line_item_with_base_measurement,
                             product: product,
                             quantity: 200)

          expect(product.purchases_balance).to eql 1_000
          expect(product.sales_balance).to eql 100
          expect(product.sales_returns_balance).to eql 50
          expect(product.spoilages_balance).to eql 50
          expect(product.received_stock_transfers_balance).to eql 50
          expect(product.internal_uses_balance).to eql 50
          expect(product.stock_transfers_balance).to eql 50
          expect(product.purchase_returns_balance).to eql 200
          expect(product.balance).to eql 650
      end

  end
end
