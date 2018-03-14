require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe PurchaseReturnLineItem do
      describe 'associations' do
        it { is_expected.to belong_to :purchase_return_order }
      end
    end
  end
end
