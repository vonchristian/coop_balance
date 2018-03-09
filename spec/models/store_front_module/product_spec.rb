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
      it { is_expected.to have_many :orders }
      it { is_expected.to have_many :sales_orders }
      it { is_expected.to have_many :purchase_orders }

    end
    context 'validations' do
    	it { is_expected.to validate_presence_of :name }
    	it { is_expected.to validate_uniqueness_of :name }
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
      context 'no purchase returns' do
        it 'unit of measurement is base measurement' do
          product = create(:product)
          order = create(:purchase_order)
          purchase = create(:purchase_line_item_with_base_measurement,  quantity: 100, product: product, order: order)

          expect(product.purchases_balance).to eql(100)
        end
        it 'unit of measurement has conversion multiplier' do
          product = create(:product)
          order = create(:purchase_order)
          purchase = create(:purchase_line_item_with_conversion_multiplier,  quantity: 100, product: product, order: order)

          expect(product.purchases_balance).to eql(5000)
        end
      end

      context 'with purchase returns' do
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
    end
  end
end
