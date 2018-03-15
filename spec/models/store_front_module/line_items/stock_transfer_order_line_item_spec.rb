require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe StockTransferLineItem do
      describe 'associations' do
        it { is_expected.to belong_to :stock_transfer_order }
        it { is_expected.to belong_to :purchase_line_item }
      end
    end
  end
end
