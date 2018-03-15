require 'rails_helper'

module StoreFrontModule
  module LineItems
    describe ReceivedStockTransferLineItem do
      describe 'associations' do
        it { is_expected.to  belong_to :received_stock_transfer_order }
      end
    end
  end
end

