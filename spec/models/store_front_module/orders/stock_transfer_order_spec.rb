require 'rails_helper'

module StoreFrontModule
  module Orders
    describe StockTransferOrder do
      describe 'associations' do
        it { is_expected.to have_many :stock_transfer_line_items }
      end
      describe 'delegations' do
        it { is_expected.to delegate_method(:name).to(:store_front).with_prefix }
      end

      it "#store_front" do
        store_front = create(:store_front, name: "Lagawe")
        stock_transfer = create(:stock_transfer_order, commercial_document: store_front)

        expect(stock_transfer.store_front).to eql(store_front)
      end
    end
  end
end
