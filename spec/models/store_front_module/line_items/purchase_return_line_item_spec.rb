require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe PurchaseReturnLineItem do
      describe 'associations' do
        it { is_expected.to belong_to :purchase_return_order }
        it { is_expected.to belong_to :purchase_line_item }
      end
    end
  end
end
