require 'rails_helper'

module StoreFrontModule
  module QuantityCalculators
    describe StoreFront do
      it "#compute" do
        store_front_1 = create(:store_front)
        order = create(:order, store_front: store_front_1)
        unit_of_measurement = create(:unit_of_measurement, conversion_quantity: 1)
        line_item = create(:line_item, order: order, quantity: 10, unit_of_measurement: unit_of_measurement)

        store_front_2 = create(:store_front)
        order_2 = create(:order, store_front: store_front_2)
        line_item = create(:line_item, order: order_2, quantity: 100, unit_of_measurement: unit_of_measurement)

        expect(described_class.new(line_items: StoreFrontModule::LineItem.all, store_front: store_front_1).compute).to eql 10
        expect(described_class.new(line_items: StoreFrontModule::LineItem.all, store_front: store_front_2).compute).to eql 100
      end
    end
  end
end
