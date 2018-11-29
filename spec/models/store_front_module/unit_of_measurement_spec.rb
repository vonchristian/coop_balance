require 'rails_helper'

module StoreFrontModule
  describe UnitOfMeasurement do
    describe 'associations' do
      it { is_expected.to belong_to :product }
      it { is_expected.to have_many :mark_up_prices }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :code }
      it { is_expected.to validate_presence_of :base_quantity }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:price).to(:current_mark_up_price) }
    end

    it "#base_quantity_and_code" do
      unit_of_measurement = build(:unit_of_measurement, base_quantity: 10, code: 'kg')

      expect(unit_of_measurement.base_quantity_and_code).to eql "10.0 / kg"
    end

    describe "#base_selling_price" do
      it "#base_measurement" do
        unit_of_measurement = create(:unit_of_measurement, base_measurement: true)
        unit_of_measurement.mark_up_prices.create(price: 100)

        expect(unit_of_measurement.base_selling_price).to eql 100
      end

      it "#not_base_measurement" do
        unit_of_measurement = create(:unit_of_measurement, base_measurement: false, conversion_quantity: 10)
        unit_of_measurement.mark_up_prices.create(price: 100)

        expect(unit_of_measurement.base_selling_price).to eql 10
      end
    end

    describe 'conversion_multiplier' do
      it "#base_measurement" do
        unit_of_measurement = create(:unit_of_measurement, base_measurement: true, base_quantity: 1)

        expect(unit_of_measurement.conversion_multiplier).to eql 1
      end

      it "#not_base_measurement" do
        unit_of_measurement = create(:unit_of_measurement, base_measurement: false, conversion_quantity: 10)

        expect(unit_of_measurement.conversion_multiplier).to eql 10
      end
    end

    it ".base_measurement" do
      base_measurement     = create(:unit_of_measurement, base_measurement: true)
      not_base_measurement = create(:unit_of_measurement, base_measurement: false)

      expect(described_class.base_measurement).to include(base_measurement)
    end

    it '.recent' do
      recent_unit_of_measurement = create(:unit_of_measurement, created_at: Date.today)
      old_unit_of_measurement = create(:unit_of_measurement, created_at: Date.today.yesterday)

      expect(described_class.recent).to eql recent_unit_of_measurement
      expect(described_class.recent).to_not eql old_unit_of_measurement
    end
  end
end
