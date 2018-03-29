module StoreFrontModule
  module Inventories
    class StockTransfersController < ApplicationController
      def index
        @line_item = StoreFrontModule::LineItems::PurchaseLineItem.find(params[:inventory_id])
        @stock_transfers = @line_item.stock_transfer_line_items.order(date: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
