require 'rails_helper'

module StoreFrontModule
  describe Product do
    context "associations" do
      it { is_expected.to belong_to :category }
    	it { is_expected.to have_many :unit_of_measurements }
      it { is_expected.to have_many :line_items }
      it { is_expected.to have_many :purchases }
      it { is_expected.to have_many :sales }
      it { is_expected.to have_many :sales_returns }
      it { is_expected.to have_many :purchase_returns }
      it { is_expected.to have_many :internal_uses }
      it { is_expected.to have_many :spoilages }
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

    describe "#purchases_balance(options)" do
      describe 'no purchase returns' do
        it 'unit of measurement is base measurement' do
          product = create(:product)
          purchase = create(:purchase_line_item_with_base_measurement,
            quantity: 100,
            product: product)
          another_purchase = create(:purchase_line_item_with_base_measurement,
            quantity: 10,
            product: product)

          expect(product.purchases_balance).to eql(110)
        end

        it 'unit of measurement has conversion multiplier' do
          product = create(:product)
          purchase = create(:purchase_line_item_with_conversion_multiplier,  quantity: 100, product: product)

          expect(product.purchases_balance).to eql(5000)
        end
      end
    end

    describe 'with purchase returns' do
      it 'unit of measurement is base measurement' do
        product = create(:product)
        order = create(:purchase_order)
        purchase = create(:purchase_line_item_with_base_measurement,  quantity: 100, product: product, order: order)
        purchase_return = create(:purchase_return_line_item_with_base_measurement, quantity: 5, product: product, order: order)

        expect(product.purchases_balance).to eql(95)
      end

      it 'unit of measurement has conversion multiplier' do
        product = create(:product)
        order = create(:purchase_order)
        purchase = create(:purchase_line_item_with_conversion_multiplier,  quantity: 100, product: product, order: order)
        purchase_return = create(:purchase_return_line_item_with_conversion_multiplier, quantity: 10, product: product, order: order)

        expect(product.purchases_balance).to eql(4500)
      end
    end

    describe "#sales_balance(options)" do
      context 'with no sales return' do
        it 'unit of measurement is base measurement' do
          product = create(:product)
          purchase_order = create(:purchase_order)
          sales_order = create(:sales_order)
          purchase = create(:purchase_line_item_with_base_measurement,  quantity: 100, product: product, order: purchase_order)
          sale = create(:sales_line_item_with_base_measurement,  quantity: 100.0, product: product, order: sales_order)

          expect(product.sales_balance).to eql(100)
          expect(product.balance).to eql(0)
        end
      end
    end

    describe "#sales_returns_balance(options)" do
      it 'returns sales returns quantity' do
        product = create(:product)
        purchase_order = create(:purchase_order)
        sales_order = create(:sales_order)
        purchase = create(:purchase_line_item_with_base_measurement,  quantity: 100, product: product, order: purchase_order)
        sale = create(:sales_line_item_with_base_measurement,  quantity: 100.0, product: product, order: sales_order)

        expect(product.sales_balance).to eql(100)
        expect(product.balance).to eql(0)

        sales_return = create(:sales_return_line_item_with_base_measurement,  quantity: 10.0, product: product, order: sales_order)

        expect(product.sales_returns_balance).to eql(10)
        expect(product.balance).to eql(10)
      end
    end

    describe "#internal_use_balance(options)" do
      it 'returns internal_use quantity' do
        product = create(:product)
        purchase_order = create(:purchase_order)
        internal_use_order = create(:internal_use_order)
        purchase = create(:purchase_line_item_with_base_measurement,  quantity: 100, product: product, order: purchase_order)
        internal_use = create(:internal_use_line_item_with_base_measurement,
          quantity: 10.0,
          product: product, order: internal_use_order, purchase_line_item: purchase)

        expect(product.internal_use_balance).to eql(10)
        expect(product.balance).to eql(90)
      end
    end

    describe "#stock_transfer_balance(options)" do
      it 'returns stock_transfer quantity' do
        product = create(:product)
        purchase_order = create(:purchase_order)
        stock_transfer_order = create(:stock_transfer_order)
        purchase = create(:purchase_line_item_with_base_measurement,  quantity: 100, product: product, order: purchase_order)
        stock_transfer = create(:stock_transfer_line_item_with_base_measurement,
          quantity: 10.0,
          product: product,
          order: stock_transfer_order)

        expect(product.stock_transfer_balance).to eql(10)
        expect(product.balance).to eql(90)
      end
    end
    describe "#received_stock_transfer_balance(options)" do
      it 'returns received_stock_transfer quantity' do
        product = create(:product)
        purchase_order = create(:purchase_order)
        received_stock_transfer_order = create(:received_stock_transfer_order)
        purchase = create(:purchase_line_item_with_base_measurement,  quantity: 100, product: product, order: purchase_order)
        received_stock_transfer = create(:received_stock_transfer_line_item_with_base_measurement,
          quantity: 10.0,
          product: product,
          order: received_stock_transfer_order)

        expect(product.received_stock_transfer_balance).to eql(10)
        expect(product.balance).to eql(110)
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
    end
  end
end
