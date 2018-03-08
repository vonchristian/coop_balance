require 'rails_helper'

module StoreFrontModule
  describe LineItem do
    describe 'associations' do
    	it { is_expected.to belong_to :cart }
      it { is_expected.to belong_to :unit_of_measurement }
      it { is_expected.to belong_to :product }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :unit_of_measurement_id }
      it { is_expected.to validate_presence_of :product_id }
    end


    describe 'delegations' do
    end

    it ".total" do
      unit_of_measurement = create(:unit_of_measurement, base_measurement: true, quantity: 1)
      line_item = create(:line_item, unit_of_measurement: unit_of_measurement, quantity: 10)
      another_line_item = create(:line_item, unit_of_measurement: unit_of_measurement, quantity: 10)

      expect(StoreFrontModule::LineItem.total).to eql(20)
    end
  end
end
