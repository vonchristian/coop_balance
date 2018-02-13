require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe PurchaseOrderLineItem, type: :model do
      describe 'associations' do
        it { is_expected.to belong_to :purchase_order }
        it { is_expected.to have_many :sales_order_line_items }
      end
      describe 'delegations' do
        it { is_expected.to delegate_method(:supplier_name).to(:purchase_order) }
      end

      it '#purchase_cost' do
        base_unit_of_measurement = create(:unit_of_measurement, base_measurement: true)
      end
    end
  end
end
