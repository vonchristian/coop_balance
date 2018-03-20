require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe SalesLineItem, type: :model do
      describe 'associations' do
        it { is_expected.to belong_to :sales_order }
        it { is_expected.to have_many :referenced_purchase_line_items }
      end
      describe 'delegations' do
        it { is_expected.to delegate_method(:customer).to(:sales_order) }
        it { is_expected.to delegate_method(:official_receipt_number).to(:sales_order) }
        it { is_expected.to delegate_method(:date).to(:sales_order) }
        it { is_expected.to delegate_method(:customer_name).to(:sales_order) }
      end
    end
  end
end
