require 'rails_helper'

module StoreFrontModule
  describe LineItem do
    describe 'associations' do
    	it { is_expected.to belong_to :cart }
      it { is_expected.to belong_to :unit_of_measurement }
      it { is_expected.to belong_to :product }
      it { is_expected.to belong_to :order }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :unit_of_measurement_id }
      it { is_expected.to validate_presence_of :product_id }
    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:balance).to(:product).with_prefix }
      it { is_expected.to delegate_method(:conversion_multiplier).to(:unit_of_measurement) }
      it { is_expected.to delegate_method(:code).to(:unit_of_measurement).with_prefix }
      it { is_expected.to delegate_method(:name).to(:product) }
      it { is_expected.to delegate_method(:employee).to(:order) }
      it { is_expected.to delegate_method(:name).to(:employee).with_prefix }
    end

    it ".total" do
     line_item = create(:sales_line_item_with_base_measurement, quantity: 10)
      another_line_item = create(:sales_line_item_with_base_measurement, quantity: 10)

      expect(described_class.total).to eql(20)
    end
    it ".processed" do
      line_item = create(:line_item, order_id: nil)
      processed_line_item = create(:sales_line_item_with_base_measurement)

      expect(described_class.processed).to include(processed_line_item)
      expect(described_class.processed).to_not include(line_item)
    end
    it ".total_cost" do
     line_item = create(:sales_line_item_with_base_measurement, total_cost: 10)
      another_line_item = create(:sales_line_item_with_base_measurement, total_cost: 10)

      expect(described_class.total_cost).to eql(20)
    end
    it "#processed?" do
      line_item = create(:line_item, order_id: nil)
      processed_line_item = create(:sales_line_item_with_base_measurement)

      expect(line_item.processed?).to be false
      expect(processed_line_item.processed?).to be true
    end
    describe 'converted_quantity' do
      it "unit of measurement is base measurement" do
        base_measurement = create(:unit_of_measurement, base_measurement: true, quantity: 1)
        line_item = create(:line_item, unit_of_measurement: base_measurement, quantity: 100)

        expect(line_item.converted_quantity).to eql 100
      end
      it "unit of measurement is has conversion" do
        not_base_measurement = create(:unit_of_measurement, base_measurement: false, quantity: 1, conversion_quantity: 10)
        line_item = create(:line_item, unit_of_measurement: not_base_measurement, quantity: 100)

        expect(line_item.converted_quantity).to eql 1000
      end
    end

  end
end
