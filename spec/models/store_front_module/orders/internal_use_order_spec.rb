require 'rails_helper'

module StoreFrontModule
  module Orders
    describe InternalUseOrder do
      describe 'associations' do
        it { is_expected.to have_many :internal_use_line_items }
      end

      it "#employee" do
        employee = create(:employee, first_name: "Juan", last_name: "Cruz")
        internal_use_order = create(:internal_use_order, commercial_document: employee)

        expect(internal_use_order.employee).to eql employee
      end
    end
  end
end
