require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe SalesPurchaseLineItem do
      describe 'associations' do
        it { is_expected.to belong_to :sales_line_item }
        it { is_expected.to belong_to :purchase_line_item }
      end
    end
  end
end
