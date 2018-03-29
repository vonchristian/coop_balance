module StoreFrontModule
  module Inventories
    class StockTransfersController < ApplicationController
      def index
        @line_item = StoreFrontModule::LineItems::PurchaseLineItem.includes(:sales => [:unit_of_measurement, :sales_line_item]).find(params[:inventory_id])
        @stock_transfers = @line_item.stock_transfers.order(date: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
