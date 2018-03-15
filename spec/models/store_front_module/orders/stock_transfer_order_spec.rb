require 'rails_helper'

module StoreFrontModule
  module Orders
    describe StockTransferOrder do
      describe 'associations' do
        it { is_expected.to have_many :stock_transfer_line_items }
      end
    end
  end
end
