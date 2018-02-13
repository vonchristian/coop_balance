require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe SalesOrderLineItem, type: :model do
      describe 'associations' do
        it { is_expected.to belong_to :sales_order }
      end
    end
  end
end
